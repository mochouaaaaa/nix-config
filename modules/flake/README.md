# Flake 基础设施模块

`modules/flake/` 只放 flake-parts 层面的全局配置，不放 NixOS、Darwin 或 Home Manager 的具体系统选项。

| 文件 | 职责 |
| --- | --- |
| `systems.nix` | `perSystem` 输出的系统集合 |
| `overlays.nix` | 全局 overlay 输出 |
| `packages.nix` | flake packages 输出 |
| `devshells.nix` | 项目开发环境 |
| `formatter.nix` | `nix fmt` 使用的格式化器 |
| `checks.nix` | `nix flake check` 的 derivation 检查 |

主机配置由 `modules/hosts.nix` 自动发现；系统选项仍应放在对应功能模块或 `hosts/<username>@<platform>/` 中。
