# 开发模块

本目录提供 Home Manager 开发语言环境与可选开发工具。语言模块可独立导入，也可以通过语言聚合模块统一组合。

## 语言模块

| 模块 ID | 职责 |
| --- | --- |
| `development.go` | Go 工具链、语言服务器、格式化工具和调试器。 |
| `development.node` | Node.js、npm 与 Yarn 配置。 |
| `development.python` | Python 工具，包括 ty、Ruff、uv 与 Playwright 浏览器运行环境。 |
| `development.rust` | rustup、Cargo 与 Rust 工具链环境。 |

## 聚合模块

- `development.languages` 导入上述四个语言模块。
- `homeManager.workstation` 角色通过 `development.languages` 组合开发语言环境。
- 本目录没有单独注册名为 `development` 的兼容性模块。

## 可选工具

`development.gui` 是独立的 Home Manager 模块，目前用于加入仓库提供的 JetBrains 支持包 `jetbra-free`，并由 Preservation 模块按需保留 JetBrains 用户数据。它不负责安装 GoLand、PyCharm 等 IDE，也不会被 `development.languages` 或 `homeManager.workstation` 自动导入。

## 平台与持久化

各语言模块根据目标平台配置对应工具。语言工具链的选择与桌面会话无关；Host 可以在没有桌面环境的情况下启用语言模块。

与工具对应的用户数据持久化声明应靠近其功能模块，并仅在相关程序启用时生效。项目本地的语言版本仍由项目自身的工具配置决定，不由全局模块推断。