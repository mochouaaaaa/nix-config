# Modules 架构

本仓库采用 **Dendritic Pattern + flake-parts + import-tree**。`modules/` 按功能域组织源文件；模块通过 `flake.modules.<class>.<name>` 注册，Host 只负责组合所需模块并声明机器差异。

模块类遵循 flake-parts 约定：

- `nixos`：NixOS 系统模块。
- `darwin`：nix-darwin 系统模块。
- `homeManager`：Home Manager 用户环境模块。

一个源文件可以注册多个模块类，也可以注册多个 aspect。源码路径用于组织文件，不等同于公开的模块 ID。

## 目录结构

```text
modules/
├── agents/         # AI Agent 工作流集成
├── appearance/     # 字体与字体外观
├── core/           # 系统基础能力、会话、Nix 与 Home Manager 集成
│   ├── boot/
│   ├── compat/
│   ├── dotfiles/
│   ├── home-manager/
│   ├── nix/
│   ├── profiles/
│   ├── session/
│   └── system/
├── darwin/         # macOS 专属系统设置
├── desktop/        # 桌面环境与可组合桌面能力
│   ├── common/
│   ├── components/
│   ├── gnome/
│   ├── hyprland/
│   ├── kde/
│   ├── niri/
│   └── programs/
├── development/    # 开发语言与工具链
│   ├── languages/
│   └── tools/
├── flake/          # Flake 全局输出、perSystem、checks 与开发环境
├── hardware/       # 音频、蓝牙、输入设备与硬件调优
├── programs/       # 用户程序与工具
│   ├── browsers/
│   ├── cli/
│   ├── desktop/
│   ├── editors/
│   ├── input-methods/
│   ├── media/
│   ├── shells/
│   ├── system/
│   └── terminals/
├── security/       # 密钥、安全策略与持久化
├── services/       # 系统服务
└── hosts.nix       # Host 自动发现与 Flake 配置输出
```

各功能域的补充说明：

- [agents/](./agents/README.md)：Agent 工具集成与数据持久化。
- [desktop/](./desktop/README.md)：桌面入口、公共能力与应用 profile 的组合方式。
- [development/](./development/README.md)：开发语言原子模块、工具链聚合入口与 GUI IDE 选择。
- [flake/](./flake/README.md)：Flake outputs、开发环境、格式化与 checks。
- [programs/](./programs/README.md)：用户程序的目录边界与平台职责。

## 功能域边界

| 功能域 | 职责 | 示例 |
| --- | --- | --- |
| `core` | 系统基础设置、Nix、会话与 Home Manager 集成 | `core.nix`、`core.home-manager` |
| `hardware` | 硬件能力与设备调优 | `hardware.audio`、`hardware.bluetooth`、`hardware.desktop` |
| `desktop` | 桌面会话、合成器与可组合桌面能力 | `desktop.hyprland`、`desktop.base`、`desktop.hardware`、`desktop.common`、`homeManager.desktop.user` |
| `programs` | 用户应用和通用工具 | `programs.git`、`programs.cli.*` |
| `agents` | Agent 工作流工具 | `agents.codex`、`agents.antigravity` |
| `development` | 语言运行时与开发工具链 | `development.go`、`development.node`、`development.python`、`development.rust`、`development.languages`、`development`、`development.gui` |
| `services` | 系统级服务 | `services.proxy`、`services.mysql` |
| `security` | 密钥、安全策略与持久化 | agenix、preservation |
| `darwin` | macOS 专属系统配置 | Homebrew、系统 defaults |
| `appearance` | 字体包、fontconfig 与字体选项 | `appearance` |

## 模块命名与组合

- 源码路径用于分类和拆分实现；对外 aspect 名称统一采用小写 kebab-case。
- 有明确功能域的 aspect 使用点号分层，例如 `desktop.launcher.vicinae`、`services.virtualisation.qemu`。
- 聚合入口可以保留短名称，例如 `desktop.common`、`programs.git`。
- 模块类使用标准名称 `nixos`、`darwin` 和 `homeManager`。
- 不同模块类拥有不同选项系统；需要组合 NixOS 与 Home Manager 时，应在 NixOS 模块中只为目标用户添加对应 HM 模块，不要把 NixOS 选项写入 HM 模块。

聚合模块通过 `imports` 组合职责单一的模块；底层模块仍保留独立注册 ID，Host 可以直接导入细粒度模块，或选择聚合入口。例如，`hardware.desktop` 组合 `hardware.audio` 与 `hardware.bluetooth`，而两个基础模块仍可单独导入。桌面能力进一步拆分为 NixOS 的 `desktop.base`、`desktop.hardware` 和 Home Manager 的 `homeManager.desktop.user`；`desktop.common` 保留为兼容聚合入口。桌面入口可以负责导入自己的公共能力，并将匹配的 Home Manager 桌面模块注入 Host 主用户。与桌面无关的代理、数据库和开发服务应由 Host 或独立 profile 显式选择，避免切换桌面时产生意外副作用。

## 外观职责

- `appearance` 负责字体选项、字体包和 fontconfig 默认字体。
- 通用桌面指针主题由 `desktop.common` 的 cursor 组件管理。
- Hyprcursor 是 Hyprland 专属能力，不应由其他桌面入口隐式启用。
- 桌面公共模块只组合多种桌面都需要的能力；桌面 Shell、Greeter、Launcher 和可选应用组保持独立组件。

## Host 与 nixpkgs 选择

Host 目录采用 `<username>@<hostname>` 命名，例如 `mochou@nixos`、`mochou@wsl` 和 `mochou@darwin`。后缀只代表主机名，不用于推断操作系统或平台。

每台主机在 `nixpkgs.json` 中声明目标架构和 Flake input：

- `system`：必填，目标平台，例如 `x86_64-linux`。
- `os`：必填，系统构造器所在的 Flake input；设为 `null` 时表示 standalone Home Manager Host。
- `home-manager`：必填，提供 Home Manager 模块和 `lib.homeManagerConfiguration` 的 Flake input。
- `home-manager-nixpkgs`：仅用于 standalone Home Manager，必填，用于选择创建 `pkgs` 的 Flake input；集成式 Home Manager Host 不应设置此字段。
- `nixosWsl`：可选布尔值；WSL Host 设为 `true`，仅适用于 NixOS，并要求 Flake inputs 中存在 `nixos-wsl`。

NixOS Host 示例：

```json
{
  "system": "x86_64-linux",
  "os": "nixpkgs",
  "home-manager": "home-manager"
}
```

Darwin Host 示例：

```json
{
  "system": "x86_64-darwin",
  "os": "nix-darwin",
  "home-manager": "home-manager-darwin"
}
```

Host 注册表会验证元数据中引用的 input 是否存在。NixOS 使用对应 input 的 `lib.nixosSystem`，Darwin 使用 `lib.darwinSystem`；集成式 Home Manager 则通过对应 input 的 NixOS 或 Darwin 模块导入。Standalone Home Manager 的 `pkgs` 由 `home-manager-nixpkgs` 选择，并启用 `allowUnfree`。

主机配置负责磁盘、引导、网络、硬件和机器级差异；通用能力应放在 `modules/`。不要使用 `builtins.getEnv` 隐式决定目标系统或 nixpkgs 来源。检查模式只通过显式的 `NIX_CONFIG_CHECK` 开关启用。

## Flake 检查模式

`modules/flake/checks.nix` 提供轻量检查和完整 Host 求值两条路径：

- 普通 `nix flake check --no-build` 会求值匹配当前 system 的 NixOS / Darwin toplevel，以及 standalone Home Manager activation package 的 derivation path，但不会构建系统闭包。
- 设置 `NIX_CONFIG_CHECK=1` 后，检查只验证 Host 元数据，不导出并求值完整系统 toplevel 和 Home Manager activation。
- treefmt 的格式检查和开发环境 derivation 仍由 Flake checks 管理。

常用命令：

```bash
just fmt
just fmt-check
just lint
just check
just validate

# 显式检查 Host 元数据
NIX_CONFIG_CHECK=1 nix flake check --no-build --impure --show-trace

# 求值具体 Host
just nixos-eval
just darwin-eval
```

`nix flake check --no-build` 只做求值与检查，不代表系统闭包已经成功构建；实际部署前仍应执行对应 Host 的 build。
