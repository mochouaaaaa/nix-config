# Mochou's Nix Configuration

<p align="center">
  <a href="https://github.com/mochouaaaaa/nix-config">
    <img alt="GitHub repository" src="https://img.shields.io/badge/Nix%20Flakes-Declarative%20Systems-7EBAE4?style=for-the-badge&logo=nixos&logoColor=white">
  </a>
  <a href="https://nixos.org/">
    <img alt="NixOS" src="https://img.shields.io/badge/NixOS-Declarative-5277C3?style=for-the-badge&logo=nixos&logoColor=white">
  </a>
  <a href="https://github.com/nix-community/home-manager">
    <img alt="Home Manager" src="https://img.shields.io/badge/Home%20Manager-enabled-6B8EAD?style=for-the-badge">
  </a>
  <!--
  <a href="https://github.com/mochouaaaaa/nix-config/stargazers">
    <img alt="GitHub stars" src="https://img.shields.io/github/stars/mochouaaaaa/nix-config?style=for-the-badge&logo=github">
  </a>
  -->
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
| `mochou@vm` | `x86_64-linux` | NixOS | 无状态 UEFI 虚拟机，Disko + Btrfs + Preservation |
| `mochou@wsl` | `x86_64-linux` | NixOS-WSL | Windows Subsystem for Linux |
| `mochou@darwin` | `x86_64-darwin` | nix-darwin | macOS 用户与系统配置 |

Host 目录名采用 `<username>@<hostname>` 格式，后缀只是主机名，不代表操作系统类型。主机清单及对应元数据位于 [hosts/](./hosts/)。

## Components

以下列出当前配置中具有代表性的组件；具体启用范围由各 Host 导入的模块决定。

| 类别 | 组件 / 能力 |
| --- | --- |
| **System Configuration** | [NixOS](https://nixos.org/)、[nix-darwin](https://github.com/nix-darwin/nix-darwin)、[Home Manager](https://github.com/nix-community/home-manager) |
| **Desktop / Compositor** | [Hyprland](https://hypr.land/)，并保留 Niri、GNOME 与 KDE 桌面入口 |
| **Desktop Shell & Greeter** | [Noctalia](https://github.com/noctalia-dev/noctalia) |
| **Application Launcher** | [Vicinae](https://github.com/vicinaehq/vicinae) |
| **Terminal** | [Kitty](https://github.com/kovidgoyal/kitty) |
| **Input Method** | Rime |
| **Development** | CLI 开发工具链、[Visual Studio Code](https://code.visualstudio.com/)、Neovim |
| **Applications** | 浏览器、数据库客户端、音频、通信、邮件、媒体、笔记、远程连接与办公软件 |
| **Secrets** | [agenix](https://github.com/ryantm/agenix) + [agenix-rekey](https://github.com/oddlama/agenix-rekey) |
| **Persistence** | [preservation](https://github.com/nix-community/preservation) |
| **Flake Architecture** | [flake-parts](https://github.com/hercules-ci/flake-parts) + [import-tree](https://github.com/vic/import-tree) |

## Architecture

### Flake 与模块组织

- [flake.nix](./flake.nix) 使用 `flake-parts.lib.mkFlake` 组装 Flake。
- `import-tree ./modules` 自动导入模块目录。
- 功能模块通过 `flake.modules.<class>.<name>` 注册，Host 通过显式 `imports` 组合模块。
- `nixos`、`darwin` 和 `homeManager` 是不同的模块类；系统模块可以在适当的位置组合对应的 Home Manager 模块。
- [modules/README.md](./modules/README.md) 记录模块目录、命名规则、Host 元数据和检查方式。

### Host 自动发现

[modules/hosts.nix](./modules/hosts.nix) 使用主机注册表扫描 `hosts/<username>@<hostname>/`。每个 Host 通过 `nixpkgs.json` 声明目标架构和构建器，不需要额外维护 `class` 或 `host.json`。

例如，NixOS Host：

```json
{
  "system": "x86_64-linux",
  "os": "nixpkgs",
  "home-manager": "home-manager"
}
```

Darwin Host：

```json
{
  "system": "x86_64-darwin",
  "os": "nix-darwin",
  "home-manager": "home-manager-darwin"
}
```

其中 `system`、`os` 和 `home-manager` 是必填字段。将 `os` 设为 `null` 表示 standalone Home Manager Host，此时还必须提供 `home-manager-nixpkgs`。WSL Host 可以设置 `nixosWsl: true`，并要求 Flake inputs 中存在 `nixos-wsl`。

### Secrets & Persistence

- 使用 agenix / agenix-rekey 管理加密秘密；不要提交明文密码、令牌、私钥或解密后的秘密。
- NixOS 持久化由 preservation 管理。Host 决定是否启用持久化，功能模块按需声明自身需要保留的目录和文件。
- 加密文件仍然属于敏感配置管理的一部分。添加或调整接收者、密钥和 rekey 配置时，应确认目标主机与用户的访问范围。

## Repository Layout

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

## Deployment

> [!WARNING]
> 这是面向个人设备的配置，不是通用安装器。Host 配置包含个人用户名、硬件、网络、磁盘布局和秘密管理相关设置。不要直接将现有 Host 部署到其他机器；请先检查并替换硬件配置、用户信息、密钥接收者、网络参数和持久化策略。

### Requirements

- Nix，启用 `nix-command` 与 Flakes。
- [just](https://github.com/casey/just)，用于调用仓库任务。
- [nh](https://github.com/nix-community/nh)，用于 NixOS / nix-darwin 构建与切换。
- 格式与静态检查工具由开发环境提供。

克隆仓库后，先查看任务列表并进入开发环境：

```bash
just
just dev
just show
```

### NixOS

默认 NixOS Host 为 `mochou@nixos`：

```bash
just nixos-eval     # 仅求值系统 toplevel
just nixos-build    # 构建系统
just nixos-boot     # 构建并设置下次启动使用的系统
just nixos-switch   # 构建并切换到新系统
just nixos-test     # 测试切换
just nixos-vm       # 构建并启动 VM
just nixos-repl     # 打开 NixOS REPL
```

切换其他 Host：

```bash
NH_HOST=mochou@wsl just nixos-eval
NH_HOST=mochou@wsl just nixos-switch
```

### Minimal VM deployment

`mochou@vm` is a small stateless UEFI guest for QEMU/UTM. It uses a virtio
disk at `/dev/vda`, a 1 GiB EFI System Partition, a Btrfs data partition with
persistent subvolumes for `/nix` and Preservation data, and a tmpfs root
filesystem.

#### Initial installation

Boot a NixOS installer in the VM, enable SSH in the installer environment, and
make sure the installer accepts your deployment SSH key. Then run:

```bash
nix run .#install-vm
```

The app defaults to `root@192.168.122.246`; override the target when needed:

```bash
INSTALL_HOST=root@<VM_IP> nix run .#install-vm
```

**Warning:** `nixos-anywhere` runs Disko and repartitions/formats the target
VM disk. This destroys existing data on `/dev/vda`. The installer asks you to
type the target host before proceeding. Use it only for initial installation
or an intentional reinstall, never for routine updates.

#### Routine deployment and updates

The locked `deploy-rs` CLI is included in the repository's development shell.
Enter it with `just dev`, then deploy:

```bash
deploy .#mochou@vm
```

You can also run the command without entering an interactive shell:

```bash
nix develop -c deploy .#mochou@vm
```

The `deploy.nodes."mochou@vm"` definition in the Flake selects the NixOS
configuration and connects as `root` to `192.168.122.246`. The system closure
is built on the target VM and deploy-rs activates the `system` profile. Its
automatic rollback and magic rollback safeguards remain enabled. Ensure the
deployment SSH key is authorized for root on the target.

### macOS (nix-darwin)

默认 Darwin Host 为 `mochou@darwin`：

```bash
just darwin-eval
just darwin-build
just darwin-switch
just darwin-repl
```

指定其他 Darwin Host：

```bash
NH_DARWIN_HOST=<username>@<hostname> just darwin-switch
```

### Flake Inputs

```bash
just lock            # 更新 flake.lock
just update          # 更新全部 inputs
just update-linux    # 更新 Linux 相关 inputs
just update-darwin   # 更新 Darwin 相关 inputs
just update-desktop  # 更新桌面环境相关 inputs
```

## Validation & Development

仓库提供统一的格式化、静态分析、Flake 检查与 Host 求值任务。

```bash
just fmt          # 格式化 Nix 文件
just fmt-check    # 检查 Nix 格式
just lint         # 运行 statix 与 deadnix
just check        # 轻量级 Flake 检查，不构建 derivations
just validate     # fmt-check + lint + check
just check-build  # 执行包含构建检查的 flake check
just --list       # 列出所有任务
```

`just check` 设置 `NIX_CONFIG_CHECK=1`，主要验证 Flake 与 Host 元数据，不会求值完整系统 toplevel，也不会构建系统闭包。需要验证具体 Host 时，执行对应的 `just nixos-eval` 或 `just darwin-eval`；部署前应进一步执行 build。完整行为说明见 [modules/README.md](./modules/README.md)。

## References

- [NixOS](https://nixos.org/)
- [Nix Flakes](https://nix.dev/concepts/flakes.html)
- [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/)
- [Dendritic Pattern](https://github.com/mightyiam/dendritic)

---

本仓库主要用于个人设备配置与学习参考。复用模块前，请检查相应软件的许可证、第三方资源和个人化配置。
