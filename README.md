# Mochou 的 Nix 配置

<p align="center">
  <a href="https://github.com/mochouaaaaa/nix-config">
    <img alt="Nix Flakes 声明式系统配置" src="https://img.shields.io/badge/Nix%20Flakes-Declarative%20Systems-7EBAE4?style=for-the-badge&logo=nixos&logoColor=white">
  </a>
  <a href="https://nixos.org/">
    <img alt="NixOS" src="https://img.shields.io/badge/NixOS-Declarative-5277C3?style=for-the-badge&logo=nixos&logoColor=white">
  </a>
  <a href="https://github.com/nix-community/home-manager">
    <img alt="Home Manager" src="https://img.shields.io/badge/Home%20Manager-enabled-6B8EAD?style=for-the-badge">
  </a>
</p>

这是我的个人 Nix 配置仓库，使用 **Nix Flakes、flake-parts、import-tree 和 Dendritic Pattern** 管理多台设备的系统与用户环境。

仓库目前覆盖三类主机：

1. **NixOS 桌面**：x86_64-linux，使用 Hyprland、Noctalia 和 Home Manager。
2. **NixOS WSL**：x86_64-linux，为 Windows Subsystem for Linux 提供独立的系统与用户环境。
3. **macOS**：x86_64-darwin，使用 nix-darwin 与 Home Manager。

配置以功能模块为中心组织，Host 只组合所需模块并声明机器差异。仓库主要用于个人设备，不应未经检查就直接部署到其他硬件或账号环境。

## 主机概览

| Host | 平台 | 系统构建器 | 主要用途 |
| --- | --- | --- | --- |
| `mochou@nixos` | `x86_64-linux` | NixOS | 主力 Linux 桌面，Hyprland |
| `mochou@remote` | `x86_64-linux` | NixOS | 专用远程安装与部署目标，QEMU/UTM、Disko + Btrfs + Preservation |
| `mochou@wsl` | `x86_64-linux` | NixOS-WSL | Windows Subsystem for Linux |
| `mochou@darwin` | `x86_64-darwin` | nix-darwin | macOS 用户与系统环境 |

Host 目录名统一采用 `<username>@<hostname>` 格式。主机清单及对应元数据位于 [hosts/](./hosts/)。

## 组件概览

以下列出当前配置中具有代表性的组件；具体启用范围由各 Host 导入的模块决定。

| 类别 | 组件 / 能力 |
| --- | --- |
| **系统配置** | [NixOS](https://nixos.org/)、[nix-darwin](https://github.com/nix-darwin/nix-darwin)、[Home Manager](https://github.com/nix-community/home-manager) |
| **桌面环境与合成器** | [Hyprland](https://hypr.land/)，并保留 Niri、GNOME 与 KDE 桌面入口 |
| **桌面 Shell 与登录管理器** | [Noctalia](https://github.com/noctalia-dev/noctalia) |
| **应用启动器** | [Vicinae](https://github.com/vicinaehq/vicinae) |
| **终端模拟器** | [Kitty](https://github.com/kovidgoyal/kitty) |
| **输入法** | Rime |
| **开发环境** | 命令行开发工具链、[Visual Studio Code](https://code.visualstudio.com/)、Neovim |
| **应用程序** | 浏览器、数据库客户端、音频、通信、邮件、媒体、笔记、远程连接与办公软件 |
| **密钥管理** | [agenix](https://github.com/ryantm/agenix) + [agenix-rekey](https://github.com/oddlama/agenix-rekey) |
| **持久化** | [preservation](https://github.com/nix-community/preservation) |
| **Flake 架构** | [flake-parts](https://github.com/hercules-ci/flake-parts) + [import-tree](https://github.com/vic/import-tree) |

## 架构说明

### Flake 与模块组织

- [flake.nix](./flake.nix) 使用 `flake-parts.lib.mkFlake` 组装 Flake。
- `import-tree ./modules` 自动导入模块目录。
- 功能模块通过 `flake.modules.<class>.<name>` 注册，Host 通过显式 `imports` 组合模块。
- `nixos`、`darwin` 和 `homeManager` 是不同的模块类；系统模块可以在适当的位置组合对应的 Home Manager 模块。
- [modules/README.md](./modules/README.md) 记录模块目录、命名规则、Host 元数据和检查方式。

### Host 自动发现

[modules/hosts.nix](./modules/hosts.nix) 使用主机注册表扫描 `hosts/` 下的目录。Host 目录名统一采用 `<username>@<hostname>` 命名。每个 Host 通过该文件声明目标架构和构建器，不需要额外维护 `class` 或 `host.json`。

NixOS Host 示例：

```json
{
  "system": "x86_64-linux",
  "os": "nixpkgs",
  "home-manager": "home-manager"
}
```

Darwin Host 示例：

```json
{
  "system": "x86_64-darwin",
  "os": "nix-darwin",
  "home-manager": "home-manager-darwin"
}
```

其中 `system`、`os` 和 `home-manager` 是必填字段。将 `os` 设为 `null` 表示 standalone Home Manager Host，此时还必须提供 `home-manager-nixpkgs`。WSL Host 可以设置 `nixosWsl: true`，并要求 Flake inputs 中存在 `nixos-wsl`。

### 密钥与持久化

- 使用 agenix / agenix-rekey 管理加密秘密；不要提交明文密码、令牌、私钥或解密后的秘密。
- NixOS 持久化由 preservation 管理。Host 决定是否启用持久化，功能模块按需声明自身需要保留的目录和文件。
- 加密文件仍然属于敏感配置管理的一部分。添加或调整接收者、密钥和 rekey 配置时，应确认目标主机与用户的访问范围。

## 仓库目录

```text
.
├── flake.nix               # Flake 入口、inputs 与模块导入
├── flake.lock              # 锁定的 Flake inputs
├── justfile                # 开发、检查与部署命令
├── hosts/                  # 每台设备的模块组合与主机级配置
├── lib/                    # Host registry、配置生成与通用 helper
├── modules/
│   ├── agents/             # AI Agent 集成
│   ├── appearance/         # 字体与外观配置
│   ├── core/               # 系统基础能力与 Home Manager profiles
│   ├── darwin/             # macOS 专属配置
│   ├── desktop/            # 桌面环境、Shell、启动器与桌面组件
│   ├── development/        # 开发语言与工具
│   ├── flake/              # Flake outputs、checks 与 devShell
│   ├── hardware/           # 音频、蓝牙、输入设备与硬件调优
│   ├── programs/            # 用户应用与命令行程序
│   ├── security/            # 密钥、权限与持久化
│   └── services/            # 系统服务
├── pkgs/                   # 自定义包
└── secrets/                # 加密秘密与 rekey 数据
```

## Just 命令

仓库使用 [Just](https://github.com/casey/just) 统一管理开发、检查、系统构建、部署和维护任务。直接运行 `just` 或 `just --list` 可以查看当前平台可用的命令。

### 基本用法与变量

```bash
just                         # 列出当前平台可用的任务
just dev                     # 进入通用开发环境
just show                    # 查看 Flake 输出
just hosts                   # 列出已注册的 Host
just host-config             # 查看当前 Host 的配置入口

# 指定 Flake 目录或 Host
NH_FLAKE=/path/to/nix-config just check
NH_HOST=mochou@wsl just eval
```

`FLAKE` 默认指向当前 Justfile 所在目录，可通过环境变量 `NH_FLAKE` 覆盖。`HOST` 根据运行平台默认选择 `mochou@nixos` 或 `mochou@darwin`，可通过 `NH_HOST` 指定其他主机。

### Flake 输入管理

```bash
just lock                    # 根据当前输入约束更新 flake.lock
just update                  # 更新全部 Flake inputs
just update-platform         # 更新当前平台相关 inputs
just update-desktop          # 更新 Plasma 桌面相关 input（Linux）
```

### 格式化与检查

```bash
just fmt                     # 使用 Flake 配置的格式化工具处理 Nix 文件
just fmt-check               # 检查 Nix 文件格式，不修改文件
just lint                    # 运行 statix 和 deadnix
just check                   # 执行轻量级 Flake 检查，不构建 derivations
just check-build             # 执行 Flake 检查并构建检查所需 derivations
just validate                # 依次执行 fmt-check、lint 和 check
just validate-hosts          # 求值当前平台选中的 Host
```

`just check` 会设置 `NIX_CONFIG_CHECK=1`，主要验证 Flake 与 Host 元数据，不会求值完整系统 toplevel，也不会构建系统闭包。需要验证具体 Host 时，执行 `just eval`；部署前应进一步执行 `just build`。

### 系统求值、构建与切换

NixOS 与 Darwin 使用相同的任务名称，Just 根据运行平台选择对应实现。

| 命令 | NixOS（Linux） | nix-darwin（macOS） |
| --- | --- | --- |
| `just eval` | 求值当前 Host 的 NixOS toplevel | 求值当前 Host 的 Darwin toplevel |
| `just build` | 构建系统，不激活 | 构建系统，不激活 |
| `just switch` | 构建并立即切换系统 | 构建并立即切换系统 |
| `just repl` | 打开 NixOS rebuild REPL | 打开加载当前 Flake 的 Nix REPL |

NixOS 另外提供以下任务：

```bash
just boot                     # 构建系统并设为下次启动默认项
just test                     # 临时激活系统，用于测试
just vm                       # 构建并启动带 Disko 磁盘配置的 VM
just desktop                  # 列出可用桌面模块并标记当前 Host 使用项
```

例如，切换到 WSL Host：

```bash
NH_HOST=mochou@wsl just eval
NH_HOST=mochou@wsl just switch
```

### Agenix 密钥维护环境

Agenix 使用独立的开发环境，不会把 `age`、`agenix-rekey` 或 `AGENIX_REKEY_ADD_TO_GIT` 注入通用开发环境。

```bash
just agenix                   # 进入 Agenix 专用开发环境
```

进入环境后，在 Flake 根目录执行：

```bash
agenix-rekey                 # 重新加密已配置的 Secret
```

也可以不进入交互式环境，直接执行：

```bash
nix develop .#agenix --command agenix-rekey
```

rekey 只负责重新加密配置的 Secret，不负责部署或激活 NixOS / Darwin 系统。执行后应检查 Git 工作区和差异，确认没有明文秘密或不应提交的文件。

### 远程安装与部署

远程目标是 NixOS Host `mochou@remote`。安装与日常部署是不同操作：

- `just remote_install` 使用 nixos-anywhere 执行首次安装或有意重装，会运行 Disko 并重新分区、格式化目标磁盘。
- `just remote_deploy` 更新现有系统，不执行磁盘重新分区。
- Linux 使用 deploy-rs；macOS 通过 SSH Store 在远程构建系统闭包并激活。

#### SSH 连接配置

在部署机器的 `~/.ssh/config` 中配置目标别名（地址和端口按实际网络调整）：

```sshconfig
Host remote
    HostName 192.168.1.7
    User mochou
    Port 2222
```

验证连接：

```bash
ssh remote
nix store ping --store ssh-ng://remote
```

#### 首次安装或重装

```bash
just remote_install ip="192.168.122.62" port="22"
```

该操作具有破坏性，会由 Disko 重新分区和格式化目标磁盘。详细步骤见 [docs/installation.md](./docs/installation.md)。不要将其用于日常系统更新。

#### 日常部署

Linux：

```bash
just remote_deploy_dry                 # 预演部署，不永久切换
just remote_deploy_dry ip="192.168.1.7" port="22"
just remote_deploy                     # 部署并激活
just remote_deploy ip="192.168.1.7" port="22"
```

macOS：

```bash
just remote_deploy                     # 通过 SSH Store 构建并激活远程 NixOS
just remote_deploy ip="192.168.1.7" port="22"
```

macOS 远程部署使用 `mochou@<IP>` 作为 SSH 目标，并要求 SSH 用户能够通过 `sudo` 执行系统激活命令。更多说明见 [docs/remote-deployment.md](./docs/remote-deployment.md)。

### Home Manager 服务（Linux）

当前架构下，Home Manager 作为 NixOS 系统切换的一部分运行，并提供以下 systemd 服务管理命令：

```bash
just hm-restart                # 重启当前用户的 Home Manager 服务
just hm-status                 # 查看服务状态
just hm-logs                   # 查看本次启动的最近服务日志
```

### Nix Store 维护

```bash
just gc                        # 清理用户与系统配置中超过 7 天的垃圾
just gc-user                   # 清理用户级垃圾
just gc-system                 # 清理系统级垃圾（需要 sudo）
just gc-roots                  # 查看自动 GC Roots
just store-verify              # 校验 Nix Store 路径完整性
just store-optimize            # 对 Nix Store 文件进行去重
```

### 命令分组与平台差异

Just 任务按用途分组，包括 `flake`、`quality`、`system`、`remote`、`home-manager`、`store`、`devShell` 和 `agenix`。带有平台限定的任务只会在对应系统上出现；NixOS 与 Darwin 共用的任务保持相同名称和参数。

完整任务定义以仓库根目录的 [justfile](./justfile) 为准。

## 部署前须知

> [!WARNING]
> 这是面向个人设备的配置，不是通用安装器。Host 配置包含个人用户名、硬件、网络、磁盘布局和秘密管理相关设置。不要直接将现有 Host 部署到其他机器；请先检查并替换硬件配置、用户信息、密钥接收者、网络参数和持久化策略。

### 基本要求

- Nix，并启用 `nix-command` 与 Flakes。
- [Just](https://github.com/casey/just)，用于调用仓库任务。
- [nh](https://github.com/nix-community/nh)，用于 NixOS / nix-darwin 构建与切换。
- 格式化与静态检查工具由开发环境提供。

克隆仓库后，建议先查看任务列表并进入通用开发环境：

```bash
just
just dev
just show
```

## 参考资料

- [NixOS](https://nixos.org/)
- [Nix Flakes](https://nix.dev/concepts/flakes.html)
- [NixOS 与 Flakes 指南](https://nixos-and-flakes.thiscute.world/)
- [Dendritic Pattern](https://github.com/mightyiam/dendritic)

---

本仓库主要用于个人设备配置与学习参考。复用模块前，请检查相应软件的许可证、第三方资源和个人化配置。
