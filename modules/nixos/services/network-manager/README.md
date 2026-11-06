# DAE + MosDNS + Mihomo 网络代理与 DNS 架构

## 1. 架构概述

本项目采用 **DAE + MosDNS + Mihomo** 组合实现 Linux（NixOS）透明代理与智能 DNS 分流。

三个组件各自负责不同的工作：

- **DAE**：负责透明代理、流量路由、DNS 接管。
- **MosDNS**：负责 DNS 查询处理、域名分类、广告过滤、缓存、ECS 和 DNS 上游选择。
- **Mihomo**：负责代理节点管理、代理策略及境外流量转发，同时为 MosDNS 提供 SOCKS5 代理通道。

设计目标：

1. 由 DAE 统一接管系统 DNS 请求。
2. 由 MosDNS 统一处理 DNS 分流，不在 DAE 中重复维护 DNS 分类规则。
3. 国内 DNS 上游直连，境外 DNS 上游通过 Mihomo 代理。
4. 国内 IP 和域名优先直连，境外流量交给 Mihomo。
5. 避免 DAE、MosDNS 和 Mihomo 之间形成代理循环。
6. 通过模块化配置降低维护成本。

## 2. 整体架构

```text
                         ┌──────────────────────┐
                         │      Applications    │
                         │   浏览器 / 系统应用  │
                         └──────────┬───────────┘
                                    │
                       DNS 查询     │     TCP / UDP 流量
                                    │
                    ┌───────────────┴──────────────┐
                    │                              │
                    ▼                              ▼
             ┌─────────────┐                ┌─────────────┐
             │     DAE     │                │     DAE     │
             │  DNS 接管   │                │  流量路由   │
             └──────┬──────┘                └──────┬──────┘
                    │                              │
                    ▼                              │
             ┌─────────────┐                       │
             │   MosDNS    │                       │
             │ DNS 策略处理│                       │
             └──────┬──────┘                       │
                    │                              │
          ┌─────────┴─────────┐                    │
          │                   │                    │
          ▼                   ▼                    │
    ┌───────────┐       ┌────────────┐             │
    │ AliDNS    │       │ NextDNS    │             │
    │ DNSPod    │       │ Quad9      │             │
    │ 国内直连  │       │ Google     │             │
    └───────────┘       │ Cloudflare │             │
                        └─────┬──────┘             │
                              │                    │
                              ▼                    │
                       ┌─────────────┐             │
                       │   Mihomo    │◄────────────┘
                       │ SOCKS5 代理 │
                       └──────┬──────┘
                              │
                              ▼
                       ┌─────────────┐
                       │  Proxy Node │
                       │   代理节点  │
                       └──────┬──────┘
                              │
                              ▼
                          Internet
```

> 图中 DNS 和普通网络流量是两条不同的处理链路。MosDNS 通过 Mihomo SOCKS5 访问境外 DNS 上游；普通应用的境外流量则由 DAE 路由至 Mihomo。

## 3. 组件职责

### 3.1 DAE

DAE 是整个网络架构的透明代理入口。

主要职责：

- 透明接管 TCP / UDP 流量。
- 接管 DNS 请求并转发给 MosDNS。
- 根据域名、IP、进程名等条件进行流量分流。
- 国内流量直连。
- 境外流量交给 Mihomo。
- 避免代理程序自身产生代理循环。

主要配置：

```text
global
    全局运行参数

node
    定义 Mihomo SOCKS5 节点

dns
    DNS 上游和 DNS 接管规则

group
    定义代理出口组

routing
    普通流量路由规则
```

DAE 只保留必要的 DNS 接管配置：

```dae
dns {
    upstream {
        mosdns: 'tcp+udp://127.0.0.1:5335'
    }

    routing {
        request {
            qname(suffix: mcdn.bilivideo.com) -> reject
            qname(suffix: mcdn.bilivideo.cn) -> reject
            qname(suffix: edge.mountaintoys.cn) -> reject
            qname(suffix: h2.smtcdns.net) -> reject

            fallback: mosdns
        }
    }
}
```

DAE 不再负责国内外 DNS 上游选择，统一交给 MosDNS。

代理节点定义：

```dae
node {
    mihomo: 'socks5://127.0.0.1:7891'
}

group {
    mihomo {
        policy: fixed(0)
    }
}
```

普通流量路由：

```dae
routing {
    # Mihomo 自身必须直连，防止代理环路
    pname(mihomo) -> must_direct
    pname(clash) -> must_direct
    pname(clash-meta) -> must_direct

    # MosDNS 跳过 DAE DNS 二次接管，
    # 但继续匹配普通流量路由规则
    pname(mosdns) -> must_rules

    # 系统服务
    pname(NetworkManager) -> direct
    pname(caddy) -> direct
    pname(kdeconnectd) -> direct
    pname(qbittorrent) -> direct
    pname(cloudflared) -> direct

    # 特定域名
    domain(suffix: bing.com) -> mihomo

    # Steam / Epic / Microsoft 等国内服务
    domain(geosite: steam@cn) -> direct
    domain(geosite: epicgames@cn) -> direct
    domain(geosite: cloudflare@cn) -> direct
    domain(geosite: microsoft@cn) -> direct

    # 私有 IP 和中国大陆 IP
    dip(geoip:private) -> direct
    dip(geoip:cn) -> direct

    # 中国大陆域名
    domain(geosite:cn) -> direct

    # 其他流量交给 Mihomo
    fallback: mihomo
}
```

注意：

- `must_direct`：强制直连，避免代理进程自身再次进入代理。
- `must_rules`：跳过 DNS 接管，但继续执行后续普通路由规则。
- `direct`：直接连接。
- `fallback: mihomo`：未匹配其他规则的流量交给 Mihomo。

### 3.2 MosDNS

MosDNS 是整个架构的 DNS 策略中心。

主要职责：

- 国内外域名分类。
- DNS 上游选择。
- DNS 缓存。
- ECS 控制。
- 广告域名过滤。
- 异常 DNS 请求过滤。
- 污染 IP 过滤。
- 主备 DNS 调度。
- DNS TTL 管理。

监听端口：

| 服务 | 地址 | 用途 |
| --- | --- | --- |
| UDP DNS | `:5335` | DNS UDP 查询 |
| TCP DNS | `:5335` | DNS TCP 查询 |
| HTTP API | `127.0.0.1:8338` | 管理、缓存操作和监控 |

DAE 的 DNS 上游指向 MosDNS：

```text
tcp+udp://127.0.0.1:5335
```

#### DNS 上游规划

| 分类 | DNS 上游 | 连接方式 |
| --- | --- | --- |
| 国内 | AliDNS | 直连 |
| 国内 | DNSPod | 直连 |
| 境外 | NextDNS | Mihomo SOCKS5 |
| 境外 | Quad9 | Mihomo SOCKS5 |
| 境外 | Google DNS | Mihomo SOCKS5 |
| 境外 | Cloudflare DNS | Mihomo SOCKS5 |
| 局域网 | 本地 DNS | 直连 |

境外上游通过：

```text
127.0.0.1:7891
```

访问 Mihomo SOCKS5。

国内上游不经过 Mihomo。

#### DNS 处理流程

```text
DNS Request
     │
     ▼
  MosDNS
     │
     ▼
  Pre Sequence
     │
     ├── 空域名过滤
     ├── QTYPE 65 过滤
     ├── 广告域名过滤
     ├── 私有 IP PTR 查询
     └── 特殊查询处理
     │
     ▼
  Main Sequence
     │
     ▼
  DNS Cache
     │
     ├── 命中缓存 ──────────────> Return
     │
     ▼
  域名分类
     │
     ├── GFW 域名
     │       │
     │       ▼
     │   境外 DNS
     │   NextDNS / Quad9
     │       │
     │       ▼
     │   Mihomo SOCKS5
     │
     ├── 非中国大陆域名
     │       │
     │       ▼
     │   境外 DNS
     │
     ├── 中国大陆域名
     │       │
     │       ▼
     │   国内 DNS
     │   AliDNS / DNSPod
     │
     └── 未分类域名
             │
             ▼
          Fallback
             │
             ▼
          境外 DNS
```

实际查询顺序以 MosDNS 的 `pre_sequence`、`main_sequence` 和各个 Sequence 定义为准。

### 3.3 Mihomo

Mihomo 负责代理节点和代理连接管理。

主要职责：

- 管理代理节点。
- 管理代理策略组。
- 根据规则选择代理出口。
- 提供 HTTP 代理和 SOCKS5 代理服务。
- 为 MosDNS 境外 DNS 上游提供 SOCKS5 通道。

监听地址：

| 服务 | 地址 | 用途 |
| --- | --- | --- |
| HTTP Proxy | `127.0.0.1:7890` | HTTP 代理 |
| SOCKS5 | `127.0.0.1:7891` | DAE 和 MosDNS 使用 |
| External Controller | 按实际配置 | API 管理 |

Mihomo 的 TUN 模式关闭，由 DAE 负责透明代理。

普通流量：

```text
Application
    │
    ▼
DAE
    │
    ▼
Mihomo SOCKS5
    │
    ▼
Mihomo Rule / Proxy Group
    │
    ▼
Proxy Node
    │
    ▼
Internet
```

境外 DNS 流量：

```text
MosDNS
    │
    ▼
Mihomo SOCKS5
    │
    ▼
Mihomo Proxy Node
    │
    ▼
Foreign DNS Provider
```

## 4. 避免代理循环

这是整个架构最重要的部分。

### 4.1 MosDNS 不应被 DAE 二次接管 DNS

DAE 中配置：

```dae
pname(mosdns) -> must_rules
```

作用：

- MosDNS 发出的 DNS 上游请求不再进入 DAE DNS 接管流程。
- 仍然继续匹配 DAE 普通路由规则。
- 国内 DNS 上游可以直连。
- 境外 DNS 上游可以继续匹配 Mihomo 代理规则。

### 4.2 Mihomo 必须直连

DAE 中配置：

```dae
pname(mihomo) -> must_direct
pname(clash) -> must_direct
pname(clash-meta) -> must_direct
```

作用：

避免 Mihomo 连接代理节点时再次进入 DAE 的 Mihomo 代理出口。

否则可能产生：

```text
DAE
 │
 ▼
Mihomo
 │
 ▼
DAE
 │
 ▼
Mihomo
 │
 ▼
循环代理
```

### 4.3 DNS 上游不能重复代理

正确设计：

```text
MosDNS
   │
   ├── 国内 DNS：直连
   │
   └── 境外 DNS：SOCKS5 -> Mihomo
```

不要同时在 MosDNS 和其他 DNS 代理层重复包装同一条上游连接。

### 4.4 SOCKS5 与 HTTP/3

MosDNS 使用 SOCKS5 时，应注意 UDP 传输能力限制。

尤其是：

- DoH over HTTP/3 使用 QUIC / UDP。
- 普通 SOCKS5 TCP 转发不能直接承载 UDP DNS 或 HTTP/3。
- 经过 SOCKS5 的境外 DoH 建议使用 HTTP/2 或 TCP。
- 不经过 SOCKS5 的直连上游，可以根据网络情况使用 HTTP/3。

因此，经过 Mihomo SOCKS5 的 Google、Cloudflare 等 DoH 上游，不应盲目启用 HTTP/3。

## 5. MosDNS 模块化配置

建议按功能拆分配置文件，而不是单纯按插件类型拆分。

```text
mosdns/
├── config.yaml
│
├── conf/
│   ├── 10-rules.yaml
│   ├── 20-upstreams.yaml
│   ├── 30-filters.yaml
│   ├── 40-cache-ecs.yaml
│   ├── 50-sequences.yaml
│   ├── 60-query.yaml
│   ├── 70-response.yaml
│   └── 80-fallback.yaml
│
└── rules/
    ├── geoip_cn.txt
    ├── geoip_private.txt
    ├── geosite_cn.txt
    ├── geosite_gfw.txt
    ├── geosite_location-!cn.txt
    └── geosite_ads-all.txt
```

### 文件职责

| 文件 | 内容 |
| --- | --- |
| `config.yaml` | 主配置、日志、API、include、DNS Server 和根处理流程 |
| `10-rules.yaml` | GeoIP、Geosite 等规则数据 |
| `20-upstreams.yaml` | AliDNS、DNSPod、NextDNS、Quad9、Google、Cloudflare、Local |
| `30-filters.yaml` | 广告过滤、空域名过滤、QTYPE 过滤、Reject Sequence |
| `40-cache-ecs.yaml` | Cache、ECS、TTL |
| `50-sequences.yaml` | DNS 上游调用包装 Sequence |
| `60-query.yaml` | 国内、境外、局域网、其他 DNS 查询 Sequence |
| `70-response.yaml` | TTL 响应处理、has_resp 判断 |
| `80-fallback.yaml` | 国内和境外主备 DNS Fallback |

### Sequence 分类示例

#### 过滤 Sequence

放在 `30-filters.yaml`：

```nix
{
  tag = "reject_2";
  type = "sequence";
  args = [
    { exec = "reject 2"; }
  ];
}

{
  tag = "reject_3";
  type = "sequence";
  args = [
    { exec = "reject 3"; }
  ];
}

{
  tag = "reject_5";
  type = "sequence";
  args = [
    { exec = "reject 5"; }
  ];
}
```

#### 上游调用包装

放在 `50-sequences.yaml`：

```nix
{
  tag = "dns_nocn_seq";
  type = "sequence";
  args = [
    { exec = "query_summary dns_nocn"; }
    { exec = "$dns_nocn"; }
  ];
}

{
  tag = "dns_cn_seq";
  type = "sequence";
  args = [
    { exec = "query_summary dns_cn"; }
    { exec = "$dns_cn"; }
  ];
}
```

#### DNS 查询处理

放在 `60-query.yaml`：

```nix
{
  tag = "query_cn";
  type = "sequence";
  args = [
    { exec = "$ecs_cn"; }
    { exec = "$dns_cn_seq"; }
  ];
}

{
  tag = "query_nocn";
  type = "sequence";
  args = [
    { exec = "$no_ecs"; }
    { exec = "$dns_nocn_seq"; }
  ];
}
```

> 以上是结构示例，不是完整可直接替换的配置。实际部署时应保留现有的污染 IP 检查、响应丢弃、缓存和 fallback 逻辑，并确认 include 的插件加载顺序及引用关系。

## 6. 缓存与 ECS 策略

### 缓存

当前采用双缓存设计：

| 缓存 | 用途 | 当前容量 |
| --- | --- | ---: |
| `cache_lan` | 局域网查询 | 8192 |
| `cache_wan` | 普通 DNS 查询 | 131072 |

当前配置使用：

```yaml
lazy_cache_ttl: 86400
```

具体缓存有效期还需要结合实际 TTL 和 MosDNS 缓存配置判断。

### ECS

采用两套 ECS 策略：

| 策略 | 用途 |
| --- | --- |
| `no_ecs` | 境外 DNS，不发送 ECS |
| `ecs_cn` | 国内 DNS，使用预设 ECS |

国内 ECS 使用固定预设地址：

```yaml
preset: 自己随便获取一个最快的CDN连接地址
mask4: 24
mask6: 48
```

ECS 会影响 CDN 的 DNS 调度结果，也涉及用户网络信息暴露，应根据实际 CDN 需求调整。

## 7. NixOS 部署注意事项

### 网络命名空间

注意：

`127.0.0.1` 只代表当前网络命名空间的 loopback。

如果 DAE 和 MosDNS 不在同一个网络命名空间，不能默认认为 DAE 可以访问 MosDNS 的 `127.0.0.1:5335`。

## 8. 故障排查

### 8.1 DNS 查询失败

检查服务：

```bash
systemctl status dae
systemctl status mosdns
systemctl status mihomo
```

测试 MosDNS：

```bash
dig @127.0.0.1 -p 5335 google.com
dig @127.0.0.1 -p 5335 www.baidu.com
```

测试 TCP DNS：

```bash
dig +tcp @127.0.0.1 -p 5335 google.com
```

### 8.2 Mihomo SOCKS5 是否可用

测试境外 DNS 上游：

```bash
curl -v \
  --connect-timeout 10 \
  --proxy socks5h://127.0.0.1:7891 \
  https://dns.google/resolve?name=google.com
```

测试境外网站：

```bash
curl -v \
  --connect-timeout 10 \
  --proxy socks5h://127.0.0.1:7891 \
  https://search.nixos.org/
```

## 9. 设计原则总结

整个架构遵循单一职责原则：

| 组件 | 负责什么 | 不负责什么 |
| --- | --- | --- |
| DAE | 透明代理、DNS 接管、流量分流 | 复杂 DNS 分类与上游策略 |
| MosDNS | DNS 分类、过滤、缓存、ECS、上游选择 | 普通应用代理节点管理 |
| Mihomo | 代理节点、策略组、代理传输 | 系统透明流量接管 |

最终数据流：

```text
普通网络流量：

Application
    │
    ▼
DAE
    │
    ├── 国内流量 ──> Direct
    │
    └── 境外流量 ──> Mihomo ──> Proxy Node


DNS 流量：

Application
    │
    ▼
DAE DNS
    │
    ▼
MosDNS
    │
    ├── 国内 DNS ──> AliDNS / DNSPod
    │
    └── 境外 DNS ──> Mihomo SOCKS5 ──> NextDNS / Quad9
```

**核心原则：DAE 管网络流量，MosDNS 管 DNS 策略，Mihomo 管代理出口。**

三者职责分离，避免重复实现相同功能，降低配置复杂度，并使 DNS 策略与代理策略可以独立维护。
