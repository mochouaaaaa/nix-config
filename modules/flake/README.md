# Flake 基础设施模块

`modules/flake/` 只存放根级 Flake 配置与平台无关的全局定义，不再存放 perSystem 功能模块。平台相关的系统列表、package set 和公共 perSystem 功能分别由 partition 负责求值。

## 模块一览

| 文件 | 职责 |
| --- | --- |
| `systems.nix` | 禁用根级 perSystem 求值；平台系统列表与 package set 由各 partition 声明。 |
| `overlays.nix` | 导出通用、NixOS、Darwin 与 standalone Home Manager 使用的 overlays。 |
| `deploy.nix` | 声明根级 `deploy.nodes`。 |

## Systems 与 package sets

根级 Flake 设置 `systems = [ ]`，不执行 perSystem 求值。平台系统列表和 package set 分别定义在：

- `partitions/nixos/per-system.nix`：`x86_64-linux`、`aarch64-linux`，使用 partition 自己的 `nixpkgs`。
- `partitions/darwin/per-system.nix`：`x86_64-darwin`、`aarch64-darwin`，使用 partition 自己的 `nixpkgs-darwin`。

两个平台都导入 `partitions/per-system.nix`。公共 packages、apps、devShell、formatter、checks 和 deploy-rs perSystem 定义直接集中在该文件中；Agenix-Rekey 的公共配置继续由 `modules/security/agenix/config.nix` 提供。每个 partition 使用自己的系统列表和 package set 独立求值，根 Flake 再合并公开输出。

## Overlays

`overlays.nix` 导出以下 overlay：

- `default`：空 overlay。
- `nixos`：公共 overlay 加入 Lix 包装。
- `darwin`：公共 overlay 加入 Lix 包装。
- `home-manager`：供 standalone Home Manager 使用的公共 overlay。

公共 overlay 汇总 NUR、VS Code 扩展集合，以及仓库统一的 Node.js 版本选择。NixOS 和 nix-darwin 的 Home Manager 集成配置与各自系统共享 package set；standalone Home Manager 使用独立 overlay。

## Development shell 与 formatter

默认 devShell 提供 `just`、`statix` 和 `deadnix`，并集成 deploy-rs CLI、treefmt-nix 和 git-hooks-nix。devShell 通过可合并选项允许其他模块扩展：

- `devShell.packages`
- `devShell.nativeBuildInputs`
- `devShell.inputsFrom`
- `devShell.env`
- `devShell.shellHook`

formatter 使用 treefmt-nix 管理 Nix 格式化和静态检查，并将 git-hooks-nix 的 pre-commit devShell 集成到默认开发环境。当前配置启用 nixfmt、deadnix 和 statix；格式化排除项包括锁文件、秘密目录和构建结果。

## Checks

每个平台系统生成以下检查：

- `devshell`：确保默认开发环境可构建。
- `host-evaluations`：将 Host 注册表元数据序列化为检查输出。
- `host-toplevels`：在完整检查模式下求值当前平台的 NixOS / Darwin toplevel derivation path。
- `home-activations`：在完整检查模式下求值 standalone Home Manager activation derivation path。
- `deploy`：在支持 deploy-rs 的系统上生成部署检查。

设置 `NIX_CONFIG_CHECK=1` 时，检查只验证 Host 元数据，不触发完整系统 toplevel、standalone Home Manager activation 或 deploy checks 的求值。正常的 `nix flake check --no-build` 会执行更完整的 Host 求值，但仍不会实际构建系统闭包。

常用入口：

```bash
just dev
deploy .#mochou@vm
just fmt
just fmt-check
just lint
just check
just check-build
```

Host 自动发现与元数据规则见 [../README.md](../README.md)。

## Platform input partitions

The flake-parts partition module separates host configuration evaluation and platform-specific input graphs:

- `partitions/nixos` owns NixOS inputs and exports `nixosConfigurations`.
- `partitions/darwin` owns nix-darwin and Darwin Home Manager inputs and exports `darwinConfigurations`.
- Root inputs remain for shared Flake infrastructure and cross-platform tooling. `nixpkgs-darwin` is isolated in the Darwin partition.
- `deploy-rs` and `nixos-anywhere` remain shared so a Darwin workstation can still run deployment and installation tools for NixOS.

The root evaluation sets `systems = [ ]`. Both platform partitions import `partitions/per-system.nix`, which contains the shared packages, apps, development shell, formatter, checks and deploy-rs perSystem definitions. The shared Agenix-Rekey configuration is imported there as well. Each partition evaluates these definitions with its own system list and package set, then the root Flake merges the public `packages`, `apps`, `checks`, `devShells`, and `formatter` outputs. The platform subflakes have independent lock graphs. After changing their inputs, refresh the locks from the repository root with `nix flake lock`; if Nix does not refresh a nested partition lock automatically, run `nix flake lock ./partitions/nixos` and `nix flake lock ./partitions/darwin` respectively.

The Host registry is input-independent and validates metadata. Each partition resolves only the inputs needed to instantiate its own Host configurations.
