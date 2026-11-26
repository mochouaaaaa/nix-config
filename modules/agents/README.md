# Agent 模块

`modules/agents/` 存放 AI 编程 Agent 的 Home Manager 集成，以及与 Agent 用户数据相关的 Preservation 声明。

## 可用模块

| 模块 ID | 实现文件 | 职责 |
| --- | --- | --- |
| `agents.antigravity` | `antigravity.nix` | 启用 Antigravity CLI，并允许用户修改其设置。 |
| `agents.codex` | `codex.nix` | 启用 Home Manager 的 Codex 程序；非 Darwin 平台允许用户修改设置。 |

## 数据持久化

对应的 NixOS Preservation aspect 会在 Home Manager 程序启用时，有条件地保留用户数据：

- Antigravity：`.antigravity-ide`
- Codex：`.config/codex`

持久化声明与 Home Manager 程序模块相互独立。单独导入持久化声明不会启用对应的 Agent。

## 模块边界

- Agent 专属的安装和设置放在此目录。
- 共享语言运行时和开发工具链放在 [development 模块](../development/README.md)。
- 普通应用和命令行工具放在 [programs 模块](../programs/README.md)。
- 凭据和 API Token 应通过仓库的加密密钥管理流程保存，不要将明文密钥写入模块文件。