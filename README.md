# Mochou 的 Nix 配置

这是一个使用 **Nix Flakes、flake-parts、import-tree 和 Dendritic Pattern** 管理多台设备的个人系统配置仓库，涵盖 NixOS、nix-darwin 与 Home Manager。

本仓库面向个人设备和当前硬件环境。复用或部署前，请先检查 Host 配置、硬件差异和密钥设置。

## 主机概览

| Host | 平台 | 系统类型 | 用途 |
| --- | --- | --- | --- |
| `mochou@nixos` | `x86_64-linux` | NixOS | Linux 桌面 |
| `mochou@remote` | `x86_64-linux` | NixOS | 远程安装与部署目标 |
| `mochou@wsl` | `x86_64-linux` | NixOS-WSL | Windows Subsystem for Linux |
| `mochou@darwin` | `x86_64-darwin` | nix-darwin | macOS |

Host 目录采用 `<username>@<hostname>` 命名。实际主机配置位于 [hosts/](./hosts/)。

## 项目结构

```text
.
├── flake.nix          # Flake 入口与输入定义
├── flake.lock         # 锁定的 Flake inputs
├── justfile           # 仓库任务入口
├── hosts/             # 各主机配置
├── lib/               # Host 注册、配置生成与辅助函数
├── modules/           # 可复用功能模块
├── docs/              # 安装与远程部署文档
├── pkgs/              # 自定义包
└── secrets/           # 加密密钥与 rekey 数据
```

## 架构概要

- 使用 flake-parts 组织 Flake 输出。
- 使用 import-tree 自动导入 `modules/` 中的模块。
- 使用 Dendritic Pattern 按功能注册模块，再由 Host 显式组合。
- NixOS、nix-darwin 和 Home Manager 分属不同模块类。
- Host 配置负责组合通用模块与声明机器差异。

## 文档索引

- [模块架构与目录索引](./modules/README.md)：模块组织方式、模块类与功能域索引。
- [桌面模块](./modules/desktop/README.md)：桌面会话与桌面组件。
- [程序模块](./modules/programs/README.md)：用户应用与工具。
- [开发模块](./modules/development/README.md)：语言环境与开发工具。
- [Agent 模块](./modules/agents/README.md)：AI 编程 Agent 集成。
- [Flake 基础设施](./modules/flake/README.md)：Flake 输出、开发环境与检查。
- [Agenix](./modules/security/agenix/README.md)：加密密钥集成与维护。
- [NixOS 安装指南](./docs/installation.md)：远程主机首次安装与重装。
- [NixOS 远程部署](./docs/remote-deployment.md)：已安装主机的日常部署。

## 参考项目

- [Nix](https://nixos.org/)
- [Nix Flakes](https://nix.dev/concepts/flakes.html)
- [flake-parts](https://github.com/hercules-ci/flake-parts)
- [import-tree](https://github.com/vic/import-tree)
- [Dendritic Pattern](https://github.com/mightyiam/dendritic)
- [Home Manager](https://github.com/nix-community/home-manager)
- [nix-darwin](https://github.com/nix-darwin/nix-darwin)

本仓库主要用于个人设备配置与学习参考。