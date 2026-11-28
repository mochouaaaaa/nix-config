# 程序模块

`modules/programs/` 存放可复用的用户应用和工具。源目录按功能组织实现文件；仓库自有模块统一通过 `flake.aspects.<aspect>.<class>` 注册，并由 flake-aspects 生成对应的 `flake.modules.<class>.<aspect>` 消费入口。程序本身的配置留在程序 Aspect 中，桌面会话专属集成则作为对应桌面 Aspect 的贡献。

## 目录布局

| 目录 / 文件 | 职责 |
| --- | --- |
| `browsers/` | Chromium、Firefox、浏览器配置档、插件及 Tridactyl 集成。 |
| `cli/` | 通用命令行工具。 |
| `desktop/` | 通用独立图形应用；其下按通信、邮件、安全、笔记、远程访问、办公、媒体和数据库等用途分组。 |
| `editors/` | Neovim、VS Code、Neovide 及其插件和语言工具。 |
| `input-methods/` | Rime、xremap 及其平台集成。 |
| `media/` | 媒体播放器及其辅助脚本。 |
| `shells/` | Shell 配置、别名、插件和辅助功能。 |
| `system/` | 用户级系统客户端，例如 SSH。 |
| `terminals/` | 终端模拟器和终端复用器。 |
| `git.nix` | Git 与 GitHub CLI 基础工具配置，对外注册为 `cli.git`。 |

## 模块边界

- Home Manager class 负责用户级应用软件包和设置。
- NixOS 与 nix-darwin class 负责需要系统权限或系统级集成的配置。
- 平台专属行为应放在对应的 `homeManager`、`nixos` 或 `darwin` Aspect 部分中。
- 可复用程序能力由 Host 或 Home Manager 角色组合；无桌面的配置不应引入可选图形应用。
- 由模块相对路径加载的配置文件应与使用它们的程序 Aspect 放在一起。

## 桌面应用配置

`desktop.programs` 聚合入口与应用分组规则统一位于 `modules/profiles/desktop/`：`programs.nix` 组合各应用组，`program-groups.nix` 定义各组包含的应用。

Host 可以导入 `desktop.programs`，也可以只选择所需的细分模块。聚合入口不会包含所有位于 `modules/programs/desktop/` 源目录下的模块。

数据库客户端由 `modules/programs/desktop/database/clients.nix` 实现，单独注册为 Home Manager Aspect `desktop.programs.database`，不包含在 `desktop.programs` 聚合入口中，而由需要它的工作站角色显式组合。API 客户端由 `modules/programs/desktop/api-clients.nix` 实现，并由 `desktop.programs` 聚合入口组合。通信、安全、邮件、笔记、远程访问等多应用类别在 `desktop/` 下使用独立子目录；单一应用类别保留独立文件。具有独立配置域的浏览器、编辑器、媒体播放器、终端和输入法仍分别放在各自功能目录。

Chromium 的 KDE 集成、Kitty 的 KDE 配置、xremap 的 KDE/Umbriel 参数和 Neovide 的 Niri 窗口规则，分别贡献给对应桌面 Aspect。

桌面会话本身由 [桌面模块](../desktop/README.md) 管理，不由应用聚合入口启用。

## 其他功能域

- AI 编程 Agent 集成见 [agents 模块](../agents/README.md)。
- 开发语言运行时与工具链见 [development 模块](../development/README.md)。
- 系统服务见 `modules/services/`，由 Host 显式选择。
