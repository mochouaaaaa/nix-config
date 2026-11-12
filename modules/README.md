# Modules 架构

本仓库采用 **Dendritic Pattern + flake-parts + import-tree**。`modules/` 按功能组织源文件，模块通过 `flake.modules.<class>.<name>` 注册；主机目录只负责选择功能模块和声明机器差异。

## 目录约定

```text
modules/
├── flake/          # flake-parts 输出、systems、overlays、checks、devShell
├── core/           # NixOS/Darwin/HM 基础能力、用户、locale、session
├── hardware/       # 音频、蓝牙、固件、设备调优
├── desktop/        # 桌面环境、通用桌面能力及可组合组件
│   ├── common/
│   ├── components/
│   ├── hyprland/
│   ├── niri/
│   ├── gnome/
│   └── kde/
├── services/       # 系统服务，按网络、数据库、虚拟化等继续分组
├── programs/       # 用户应用和工具
├── development/    # 开发语言与工具链
├── security/       # 密钥、权限、持久化、安全策略
├── appearance/     # 字体、主题、光标
├── darwin/         # macOS 专属系统能力
└── hosts.nix       # 自动发现 hosts/<username>@<hostname>/
```

## 模块命名

模块文件的路径只用于组织源码；对外注册的 aspect 名称统一采用小写 kebab-case；有明确功能域的模块统一使用 `域.功能` 点号分层，避免把域名和功能名用连字符拼在一起。聚合入口（如 `programs`、`development`、`desktop.common`）可以保留短名称。模块类保持 flake-parts 的标准名称（`nixos`、`darwin`、`homeManager`），模块名以注册声明为准。

## 桌面环境组合

桌面模块分为 NixOS 和 Home Manager 两个模块类，因为二者的选项系统不同。桌面入口可以负责把对应 HM 模块注入到 `home-manager.users.<user>.imports`，从而让主机只导入一个桌面入口，而不是分别导入 NixOS/HM 两份配置。

桌面入口只组合桌面所需能力。代理、数据库、开发工具等与桌面无关的服务应由主机或独立 profile 显式导入，避免切换桌面时意外启停服务。

## 主机与 nixpkgs 选择

主机目录采用 `<username>@<hostname>` 命名，例如 `mochou@nixos`、`mochou@work` 或 `mochou@home`。目录后缀只是主机名，不代表操作系统或平台类型。

每台主机目录下通过 `host.json` 声明配置类别和目标架构：

```json
{
  "class": "nixos",
  "system": "x86_64-linux"
}
```

支持的 `class` 为 `nixos`、`darwin` 和 `home`（standalone Home Manager）。`system` 声明目标系统架构，不取决于执行 Flake 检查的机器架构。

系统 nixpkgs 源根据目标架构自动选择：

| class | system | 系统 nixpkgs |
| --- | --- | --- |
| `nixos` | Linux 架构 | `nixpkgs` |
| `darwin` | `x86_64-darwin` | `nixpkgs-darwin` |
| `darwin` | 其他 Darwin 架构 | `nixpkgs` |
| `home` | 任意支持架构 | 不使用系统 nixpkgs |

Home Manager 保留现有策略：Darwin 跟随系统 nixpkgs；NixOS 和 standalone Home Manager 使用 `nixpkgs-stable`。新增主机只需添加目录和 `host.json`，不需要修改中央平台映射表。

NixOS 使用所选 nixpkgs input 的 `lib.nixosSystem` 构造系统；内嵌 Home Manager 保持 `useGlobalPkgs = false`，并通过 `pkgsPath` 使用稳定版 nixpkgs。Darwin 通过 nix-darwin 的 `nixpkgs.source` 选择系统包源，Home Manager 保持 `useGlobalPkgs = true`，跟随 Darwin 系统包集。Standalone Home Manager 则直接从 `nixpkgs-stable` 导入 pkgs。

主机配置负责声明磁盘、引导、网络等机器差异；通用功能应放在 `modules/`，不要复制到主机目录。不要使用 `builtins.getEnv` 隐式决定目标系统或 nixpkgs 来源；`NIX_CONFIG_CHECK` 仅用于显式切换轻量级检查模式。

## 修改后检查

```bash
nix fmt
NIX_CONFIG_CHECK=1 nix flake check --no-build --impure --show-trace
nix eval '.#nixosConfigurations."mochou@nixos".config.programs.hyprland.enable'
```

`just check` 会设置 `NIX_CONFIG_CHECK=1`，在该模式下暂时不导出 `nixosConfigurations`、`darwinConfigurations` 和 `homeConfigurations`，因为 Nix 自身的 `nix flake check` 会强制求值 NixOS toplevel。此模式下的 `host-evaluations` 只检查轻量级主机元数据，不会遍历主机 packages，也不会触发 `mochou_nur`。正常执行 build/switch 时不设置该变量，所有主机输出和包仍按原样启用。直接运行检查时请使用 `NIX_CONFIG_CHECK=1 nix flake check --no-build --impure`。

`nix flake check --no-build` 只做评估/检查，不代表系统闭包已经成功构建；实际部署前仍应执行对应主机的 build。
