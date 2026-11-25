# Agent 模块

`modules/agents/` 存放 AI 编程 Agent 和面向 Agent 的开发工具的 Home Manager 集成。它们与普通应用分开管理，因为这些模块不仅配置应用本身，也可能声明 Agent 状态数据的持久化规则。

## 可用模块

| 模块 ID | 实现文件 | 职责 |
| --- | --- | --- |
| `agents.antigravity` | `antigravity.nix` | 启用 Antigravity CLI 集成，并允许其设置由用户修改。 |
| `agents.codex` | `codex.nix` | 启用 Home Manager 的 Codex 程序；非 Darwin 平台允许用户修改设置。 |

## 数据持久化

这些文件中的 NixOS preservation aspect 会在对应 Home Manager 程序启用时，有条件地保留 Agent 的用户数据：

- Antigravity：`.antigravity-ide`
- Codex：`.codex`

持久化声明与 Home Manager 程序模块相互独立。单独导入持久化声明不会启用对应的 Agent。

## 模块边界

- Agent 专属的安装和设置放在此目录。
- 共享语言运行时和开发工具链放在 `modules/development/`。
- 普通应用和命令行工具放在 `modules/programs/`。
- 凭据和 API Token 必须通过仓库的加密密钥管理流程保存，不要将明文密钥写入模块文件。

新增 Agent 集成时，只有当它拥有独立的 Agent 工作流或状态目录时，才应在此目录增加对应模块。
