# Profiles

本目录集中存放仓库的组合规则、角色定义与可选配置 Profile。这里不放功能实现；功能模块仍按职责留在 `core/`、`programs/`、`services/`、`hardware/`、`desktop/` 等领域目录。

## 约定

- **功能模块**定义单一能力及其配置，放在对应领域目录。
- **Profile / Role**通过 `includes` 组合同 class 功能模块；跨 class 组合通过 `forward` 完成。
- **Host Profile**集中声明每种 Host 角色选择的 Home Manager 角色，并将这些角色转发到 Host 元数据中的用户。
- Host Profile Aspect ID 使用 `host.<username>.<hostname>`；用户名只从 Host 元数据取得，并动态组成唯一的 Host Profile ID；公共模块中不得硬编码具体用户名。
- Host 目录通过 `self.modules.<class>."host.${username}.${hostName}"` 引入对应 Profile；`hostName` 与 `username` 均由 Host 注册器解析并作为 specialArgs 提供。
- **Compatibility profile**为旧模块 ID 提供兼容入口，也放在本目录。
- **Policy profile**表达可选系统策略，例如 FHS 兼容环境与性能调优（如 zram）。
- 组合规则可以定义原有 Aspect ID；移动文件不改变 Aspect ID，因此消费者引用保持不变。
- 组合文件不应顺带引入与组合职责无关的系统副作用。确有额外配置时，应评估它是否属于独立功能模块。

## 目录

| 路径 | 职责 |
| --- | --- |
| `core.nix` | Core 基础能力聚合。 |
| `development.nix` | 开发语言环境聚合。 |
| `desktop/` | 桌面公共入口、图形应用分组及总聚合。 |
| `hardware/` | 硬件兼容入口与组合规则。 |
| `services/` | 服务基础入口、兼容入口和数据库聚合。 |
| `home-manager/` | CLI、服务器和工作站用户角色。 |
| `hosts.nix` | 从 Host 元数据生成 NixOS、Darwin、WSL 和远程 Host Profile，并动态转发 Home Manager 角色。 |
| `compat.nix` | 兼容性策略 Profile。 |
| `performance/zram.nix` | 可选性能策略 Profile。 |

## 领域边界

不要将功能模块仅因其使用了 `includes` 就移动到这里。例如 `hardware.desktop` 同时组合音频、蓝牙并定义内核模块，因此仍是硬件功能；`desktop.base`、`desktop.hardware` 和 `desktop.user` 也包含实际配置，应留在桌面功能目录。
