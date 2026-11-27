# 模块架构

本仓库使用 **Dendritic Pattern、flake-parts、flake-aspects 与 import-tree** 组织配置。此目录存放可复用配置能力；所有仓库自有模块统一以 Aspect 作为源定义，由 Host 按需组合。

## Aspect 与模块类

仓库自有模块统一通过 `flake.aspects.<aspect>.<class>` 注册。flake-aspects 会将其转置为 `flake.modules.<class>.<aspect>`，因此 Host 和其他模块仍可通过生成的模块入口导入；新定义不应再直接注册 `flake.modules.*`。

- `nixos`：NixOS 系统模块。
- `darwin`：nix-darwin 系统模块。
- `homeManager`：Home Manager 用户环境模块。
- 其他自定义模块类可按需使用，但必须与对应模块系统的集成方式一致。

同一个 Aspect 可以同时提供多个 class 的配置，但 class 之间不会自动传播。需要跨 class 配置时，必须分别定义对应 class 的部分，并由 NixOS、Darwin 或 Host 入口显式桥接。

## 组合原则

- 通过 `includes` 组合其他 Aspect；依赖应保持在相同 class 内。
- `imports` 用于引入外部 flake 模块、第三方模块，或确实需要直接使用模块系统导入语义的配置。
- Aspect 生成的 `self.modules.<class>.<aspect>` 是兼容与消费入口，不是仓库内部新模块的注册方式。
- 功能 Aspect 保持职责单一；聚合 Aspect 只组合其他能力，不应隐藏额外副作用。
- 平台差异放在对应 class 中；跨平台 Aspect 只保留真正通用的配置。
- Preservation、选项声明、系统基础设施等也以 Aspect 注册；它们仍然可以保持独立 ID 和按需组合。

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

## Host 注册

Host 位于仓库根目录的 `hosts/<username>@<hostname>/`。模块目录中的 [hosts.nix](./hosts.nix) 与 Host 注册逻辑负责发现主机并生成 Flake 配置输出；Host 元数据由各主机目录中的 `nixpkgs.json` 提供。

当前元数据使用 `system`、`system-input`、`home-manager-input` 等字段声明目标平台与构建输入。Standalone Home Manager Host 还可以单独指定 `home-manager-nixpkgs`。具体字段定义以 [host-options.nix](./host-options.nix) 和 [lib/host-registry.nix](../lib/host-registry.nix) 为准。

主机级硬件、磁盘、网络和引导设置应留在对应 Host；可复用能力放在功能 Aspect 中。
