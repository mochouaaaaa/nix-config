# NixOS 远程部署

本文说明 Just 中远程部署命令的作用，以及 Linux 和 macOS 平台如何将配置部署到 Flake Host `mochou@remote`。

## 名称与对应关系

| 名称 | 示例 | 含义 |
| --- | --- | --- |
| Flake Host | `mochou@remote` | NixOS 配置输出，对应 `hosts/mochou@remote/` |
| 目标地址 | `192.168.122.62` | 目标主机 SSH 服务可访问的 IP 地址或主机名 |
| SSH 端口 | `22` | 目标主机 SSH 服务监听的端口 |

`remote` 是 Flake Host 名称的一部分，不是 Nix 内置关键字，也不是必须通过 DNS 解析的主机名。当前 Just 配方通过 IP/主机名和端口连接目标机。

## Just 命令

Just 根据运行平台选择带有平台属性的配方。同名的 `remote_deploy` 在 Linux 和 macOS 上采用不同部署方式：

| 平台 | 命令 | 部署方式 |
| --- | --- | --- |
| Linux | `just remote_deploy_dry` | deploy-rs 预演激活 |
| Linux | `just remote_deploy` | deploy-rs 部署 |
| macOS | `just remote_deploy` | 通过 Nix SSH Store 远程构建并激活 |

Linux 和 macOS 的 `remote_deploy` 都接受 `ip` 与 `port` 参数，默认值分别为 `192.168.122.62` 和 `22`。

### Linux：deploy-rs

先预演，不切换目标系统：

```bash
just remote_deploy_dry
just remote_deploy_dry ip="192.168.1.7"
just remote_deploy_dry ip="192.168.1.7" port="2222"
```

确认目标地址和激活计划无误后，再正式部署：

```bash
just remote_deploy
just remote_deploy ip="192.168.1.7"
just remote_deploy ip="192.168.1.7" port="2222"
```

deploy-rs 节点以 `root` 用户连接目标机。部署机必须持有已授权给目标机 root 用户的 SSH 密钥。这里的 `ip` 是地址或主机名，不是 SSH 配置别名；配方会将 `port` 转换为 SSH 的 `-p` 参数。

### macOS：Nix SSH Store

macOS 配方不使用固定的 SSH 别名，也不依赖 `~/.ssh/config` 中的 `Host remote` 项。目标地址和端口由 Just 参数提供：

```bash
just remote_deploy
just remote_deploy ip="192.168.1.7"
just remote_deploy ip="192.168.1.7" port="2222"
```

配方以 `mochou@<ip>` 作为 SSH Store 目标，并执行以下步骤：

1. 求值并构建 `nixosConfigurations."mochou@remote".config.system.build.toplevel`。
2. 使用 `ssh-ng://mochou@<ip>` 作为 Nix Store，将构建结果传输到目标机。
3. 通过 SSH 连接目标机。
4. 使用 `sudo nix-env` 将系统 profile 更新为新的 toplevel。
5. 执行 `switch-to-configuration switch` 激活新系统。

目标机的 `mochou` 用户必须能够通过 `sudo` 执行系统 profile 更新和激活命令。配方使用带 TTY 的 SSH 连接，以便在需要时输入 sudo 密码。

## 首次安装与日常部署的区别

`remote_install` 用于首次安装或明确重装：它调用 nixos-anywhere 和 Disko，可能重新分区、格式化目标磁盘并销毁已有数据。

`remote_deploy` 用于已有 NixOS 主机的日常配置更新，不会执行 Disko，也不会重新安装系统。

Linux 上的安装配方需要显式提供 IP 和 SSH 端口：

```bash
just remote_install <TARGET_IP> <SSH_PORT>
```

不要将 `remote_install` 用于普通配置变更。执行安装前，务必核对目标主机和磁盘，并完成安装器要求的两次确认。
