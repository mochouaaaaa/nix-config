# 模块架构

本仓库使用 **Dendritic Pattern、flake-parts 与 import-tree** 组织配置。此目录存放可复用模块；模块在 Flake 中注册，由 Host 按需组合。

## 模块类

模块通过 `flake.modules.<class>.<name>` 注册。模块类区分配置所属的选项系统：

- `nixos`：NixOS 系统模块。
- `darwin`：nix-darwin 系统模块。
- `homeManager`：Home Manager 用户环境模块。

同一个源文件可以注册多个模块类或多个模块 ID。源文件路径用于组织实现，不必与公开模块 ID 一一对应。

## 目录索引

| 目录 | 范围 | 详细说明 |
| --- | --- | --- |
| [agents/](./agents/README.md) | AI 编程 Agent 集成 | Agent 模块说明 |
| [appearance/](./appearance/) | 字体与外观 | — |
| [core/](./core/) | 系统基础能力、会话与 Home Manager 角色 | — |
| [darwin/](./darwin/) | macOS 系统配置 | — |
| [desktop/](./desktop/README.md) | 桌面会话与组件 | 桌面模块说明 |
| [development/](./development/README.md) | 开发语言与工具 | 开发模块说明 |
| [flake/](./flake/README.md) | Flake 全局输出、开发环境与检查 | Flake 基础设施说明 |
| [hardware/](./hardware/) | 硬件能力与设备调优 | — |
| [programs/](./programs/README.md) | 用户应用与工具 | 程序模块说明 |
| [security/](./security/) | 密钥、安全与持久化 | [Agenix 说明](./security/agenix/README.md) |
| [services/](./services/) | 系统服务 | — |
| [hosts.nix](./hosts.nix) | Host 配置输出注册 | — |

## 组合原则

- 功能模块保持职责单一，Host 负责选择需要的功能。
- 聚合模块只负责组合其他模块，不应隐藏额外的系统副作用。
- NixOS、Darwin 和 Home Manager 模块应写入各自模块类对应的选项。
- 需要同时配置系统与用户环境时，由系统模块显式组合目标用户的 Home Manager 模块。
- 平台差异放在对应平台的模块中；跨平台模块只保留真正通用的配置。

## Host 注册

Host 位于仓库根目录的 `hosts/<username>@<hostname>/`。模块目录中的 [hosts.nix](./hosts.nix) 与 Host 注册逻辑负责发现主机并生成 Flake 配置输出；Host 元数据由各主机目录中的 `nixpkgs.json` 提供。

当前元数据使用 `system`、`system-input`、`home-manager-input` 等字段声明目标平台与构建输入。Standalone Home Manager Host 还可以单独指定 `home-manager-nixpkgs`。具体字段定义以 [host-options.nix](./host-options.nix) 和 [lib/host-registry.nix](../lib/host-registry.nix) 为准。

主机级硬件、磁盘、网络和引导设置应留在对应 Host；可复用能力放在功能模块中。