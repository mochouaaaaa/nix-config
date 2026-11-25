# 程序模块

`modules/programs/` 存放可复用的用户应用和工具。源目录按功能组织实现文件；公开的 Dendritic 模块 ID 由各文件中的 `flake.modules.*` 属性声明，不要求与源文件路径完全一致。

## 目录布局

| 目录 / 文件 | 职责 |
| --- | --- |
| `browsers/` | Chromium 和 Firefox，包含平台专属配置、配置档、插件及 Tridactyl 集成。 |
| `cli/` | 没有更具体功能域归属的命令行工具，例如 bat、btop、direnv、eza、fd、fzf、jq、lazygit、nh、ripgrep、television、yazi 和 zoxide。 |
| `desktop/` | 按用途分组的图形应用：音频、身份验证、通信、邮件、游戏、网络、笔记、远程访问和办公。 |
| `editors/` | Neovim、VS Code 和 Neovide，包括编辑器插件、语言工具和平台专属配置。 |
| `input-methods/` | Rime 和 xremap 配置及其平台集成。 |
| `media/` | 媒体播放器及其辅助脚本；mpv 配置和脚本与 mpv 模块放在一起。 |
| `shells/` | Shell 配置，目前包含 Zsh 别名、设置、插件和代理辅助功能。 |
| `system/` | 用户级系统客户端和基础配置，例如 SSH 客户端。 |
| `terminals/` | 终端模拟器和复用器，包括 Kitty 和 tmux。 |
| `git.nix` | 共享 Git 与 GitHub CLI 配置，对外注册为 `programs.git`。 |

## 模块边界

- Home Manager 模块负责用户级应用软件包和设置。
- NixOS 与 nix-darwin 模块负责系统服务、系统软件包、持久化声明，以及需要系统级集成的 Homebrew cask。
- 平台专属行为应放在对应的 `homeManager`、`nixos` 或 `darwin` 模块中，不要强行塞入跨平台定义。
- 可复用程序模块由所属 Host 或角色导入。无桌面的 CLI / 服务器组合中不要引入可选桌面应用。
- 通过相对路径加载的文件（例如 `tridactylrc` 和 `p10k.zsh`）应与使用它们的模块放在一起。

## 桌面应用分组

`modules/programs/desktop/profiles.nix` 注册兼容性聚合入口 `desktop.programs`。它会导入 API 客户端、浏览器、音频、安全、通信、邮件、媒体、笔记、远程访问、办公和网络等独立的 `desktop.programs.*` 分组。

需要精简应用集合的 Host 应导入单独分组，而不是聚合入口。数据库客户端单独维护在 `modules/desktop/programs/db-clients.nix`，注册为 `desktop.programs.database`；API 客户端也在 `modules/desktop/programs/` 下实现。

桌面会话本身由 `modules/desktop/` 配置，而不是在这里配置。详见 [桌面模块说明](../desktop/README.md)。

## 嵌套程序模块

程序的可复用配置应由该程序自身维护，而不是放在宽泛的桌面 profile 中。例如，`programs.mpv` 负责 ModernZ 选项、播放状态脚本和语言资源；桌面应用分组只负责选择 Host 用户环境中包含哪些应用。

AI Agent 集成位于 [agents 模块](../agents/README.md)。开发语言运行时和工具链位于 `modules/development/`；安全相关配置位于 `modules/security/`。
