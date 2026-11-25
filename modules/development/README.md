# 开发模块

开发语言模块均为 Home Manager 模块。每种语言都可以独立选择；聚合入口仅用于提供便捷的组合方式。

## 语言模块

| 模块 ID | 职责 |
| --- | --- |
| `development.go` | Go 工具链、语言服务器、格式化工具、调试器和 Go 环境。 |
| `development.node` | npm / Node.js 与 Yarn 配置。 |
| `development.python` | Python 工具（ty、Ruff、uv）和 Playwright 浏览器运行环境。 |
| `development.rust` | rustup 以及 Cargo / Rustup 环境。 |

## 聚合入口

- `development.languages` 导入上述四个语言模块。
- `development` 是兼容性入口，导入 `development.languages`。`homeManager.workstation` 角色继续使用此 ID，因此现有工具链选择保持不变。
- `development.gui` 是独立的可选 Home Manager 模块，用于图形化 IDE 集成。启用 Go 时会按条件加入 GoLand，启用 ty 时会按条件加入 PyCharm，并加入 JetBrains 支持包。它不会被 `development` 或 `workstation` 自动导入。

Host 可以按需导入一个或多个原子语言模块，而不必启用完整聚合入口。数据持久化声明仍放在拥有对应用户状态的语言/工具模块旁边，不会合并进 Home Manager 聚合入口。

## 平台说明

Go 的项目路径在 Darwin 与其他平台上有所不同。Node.js 和 npm 使用相同的 Node.js 软件包版本。全局持久化模块不会推断项目本地的 Node.js 版本。

JetBrains IDE 属于可选图形开发工具，应由具备桌面环境的 Host 通过 `development.gui` 显式选择。
