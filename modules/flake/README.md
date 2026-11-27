# Flake 基础设施模块

`modules/flake/` 存放 flake-parts 层面的全局配置与 `perSystem` 输出，不承载 NixOS、Darwin 或 Home Manager 的具体系统选项。模块由 import-tree 自动导入，共同组成 Flake 的系统、包、开发环境、格式化和检查输出。

## 模块索引

| 文件 | 职责 |
| --- | --- |
| `systems.nix` | 声明支持的平台，并为各平台的 perSystem 输出选择 nixpkgs package set。 |
| `overlays.nix` | 导出供 NixOS、Darwin 和 standalone Home Manager 使用的 overlays。 |
| `packages.nix` | 定义 perSystem packages 输出。 |
| `apps.nix` | 定义 Flake App，包括远程 NixOS 安装入口。 |
| `deploy.nix` | 声明 deploy-rs 节点、部署配置和相关检查。 |
| `devshells.nix` | 定义默认开发 Shell 及其可扩展接口。 |
| `formatter.nix` | 集成 treefmt-nix 与 git-hooks-nix，提供格式化和提交前检查。 |
| `checks.nix` | 定义 Flake checks，包括开发环境、格式化与 Host 检查。 |

## Host 注册

`hosts/` 子目录包含 Host 元数据选项定义与 Flake 配置注册逻辑。它与 `modules/flake/` 中的全局输出模块同属 Flake 基础设施，但单独分目录，避免与普通系统功能 Aspect 混杂。

## 支持的平台

`systems.nix` 声明以下平台：

- `x86_64-linux`
- `aarch64-linux`
- `x86_64-darwin`
- `aarch64-darwin`

perSystem 默认使用主 `nixpkgs` input；`x86_64-darwin` 使用专用的 `nixpkgs-darwin` input。该选择只影响 perSystem 输出，不替代 Host 元数据中声明的系统构造器输入。

## Overlays

`overlays.nix` 导出以下 overlay：

- `default`：空 overlay。
- `nixos`：公共 overlay 与 Lix 包装。
- `darwin`：公共 overlay。
- `home-manager`：供 standalone Home Manager 使用的公共 overlay。

公共 overlay 汇总 NUR、VS Code 扩展集合和仓库统一的 Node.js 版本选择。NixOS 与 nix-darwin 集成的 Home Manager 共享各自系统的 package set；standalone Home Manager 使用独立 package set。

## 开发环境与格式化

默认 `devShells.default` 提供通用开发工具，并通过可合并选项允许其他模块扩展：

- `devShell.packages`
- `devShell.nativeBuildInputs`
- `devShell.inputsFrom`
- `devShell.env`
- `devShell.shellHook`

功能专用工具应注册为独立的命名 devShell，避免将专用依赖加入默认环境。

`formatter.nix` 使用 treefmt-nix 管理格式化与静态检查，并将 git-hooks-nix 的 pre-commit devShell 集成到开发环境。具体启用的检查器和排除规则以该文件为准。

## Flake 检查

`checks.nix` 为每个平台定义开发环境和 Host 检查：

- `devshell`：验证默认开发环境 derivation。
- `host-evaluations`：序列化 Host 注册表元数据。
- `host-toplevels`：完整检查模式下求值当前平台的 NixOS / Darwin toplevel derivation path。
- `home-activations`：完整检查模式下求值 standalone Home Manager activation derivation path。

设置 `NIX_CONFIG_CHECK=1` 时，检查走轻量路径，只验证 Host 元数据，不求值系统 toplevel 或 standalone Home Manager activation。普通的 `nix flake check --no-build` 会执行更完整的求值，但不会实际构建系统闭包。

Just 命令、Agenix 专用开发环境和远程部署的操作步骤不在本文件展开；分别以仓库根目录的 `justfile`、[Agenix 说明](../security/agenix/README.md) 和 [远程部署指南](../../docs/remote-deployment.md) 为准。