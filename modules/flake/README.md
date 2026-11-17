# Flake 基础设施模块

`modules/flake/` 存放 flake-parts 层面的全局配置与 `perSystem` 输出，不放 NixOS、Darwin 或 Home Manager 的具体系统选项。模块由 `import-tree` 自动导入，并共同组成 Flake 的开发、构建和检查接口。

## 模块一览

| 文件 | 职责 |
| --- | --- |
| `systems.nix` | 声明支持的构建平台，并为 perSystem 输出选择对应的 nixpkgs package set。 |
| `overlays.nix` | 导出通用、NixOS、Darwin 与 standalone Home Manager 使用的 overlays。 |
| `packages.nix` | 定义 perSystem packages 输出；默认包目前为 `hello`。 |
| `apps.nix` | 提供 x86_64-linux 下的 `install-vm` 初次安装与 `deploy-vm` 日常更新入口。 |
| `devshells.nix` | 定义可扩展的默认开发 Shell，以及基础开发工具。 |
| `formatter.nix` | 集成 treefmt-nix 与 git-hooks-nix，配置 `nix fmt` 和提交前格式检查。 |
| `checks.nix` | 定义 Flake checks，包括开发环境、格式检查与 Host 元数据 / 求值检查。 |

## Systems 与 package sets

`systems.nix` 声明以下 perSystem 平台：

- `x86_64-linux`
- `aarch64-linux`
- `x86_64-darwin`
- `aarch64-darwin`

perSystem 默认使用主 `nixpkgs` input；由于当前 unstable package set 不再支持 Intel macOS，`x86_64-darwin` 会改用专用的 `nixpkgs-darwin` input。此选择针对 Flake 的 perSystem 输出，不改变各 Host 在 `hosts/*/nixpkgs.json` 中声明的系统构造器。

## Overlays

`overlays.nix` 导出以下 overlay：

- `default`：空 overlay。
- `nixos`：公共 overlay 加入 Lix 包装。
- `darwin`：公共 overlay 加入 Lix 包装。
- `home-manager`：供 standalone Home Manager 使用的公共 overlay。

公共 overlay 汇总 NUR、VS Code 扩展集合，以及仓库统一的 Node.js 版本选择。NixOS 和 nix-darwin 的 Home Manager 集成配置与各自系统共享 package set；standalone Home Manager 使用独立 overlay。

## Development shell 与 formatter

默认 devShell 提供 `just`、`statix` 和 `deadnix`，并通过可合并选项允许其他模块扩展：

- `devShell.packages`
- `devShell.nativeBuildInputs`
- `devShell.inputsFrom`
- `devShell.env`
- `devShell.shellHook`

`formatter.nix` 使用 treefmt-nix 管理 Nix 格式化和静态检查，并将 git-hooks-nix 的 pre-commit devShell 集成到默认开发环境。当前配置启用 nixfmt、deadnix 和 statix；格式化排除项包括锁文件、秘密目录和构建结果。

## Checks

`checks.nix` 为每个系统生成开发环境和 Host 检查：

- `devshell`：确保默认开发环境可构建。
- `host-evaluations`：将 Host 注册表元数据序列化为检查输出。
- `host-toplevels`：在完整检查模式下求值当前平台的 NixOS / Darwin toplevel derivation path。
- `home-activations`：在完整检查模式下求值 standalone Home Manager activation derivation path。

设置 `NIX_CONFIG_CHECK=1` 时，检查只验证 Host 元数据，不触发完整系统 toplevel 或 standalone Home Manager activation 的求值。该模式用于轻量级验证；正常的 `nix flake check --no-build` 会执行更完整的 Host 求值，但仍不会实际构建系统闭包。

常用入口：

```bash
just dev
just fmt
just fmt-check
just lint
just check
just check-build
```

Host 自动发现与元数据规则见 [../README.md](../README.md)。
