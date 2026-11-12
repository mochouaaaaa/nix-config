# Modules 架构

本仓库采用 **Dendritic Pattern + flake-parts + import-tree**。\`modules/\` 按功能组织源文件，模块通过 \`flake.modules.<class>.<name>\` 注册；主机目录只负责选择功能模块和声明机器差异。

## 目录约定

\`\`\`text
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
└── hosts.nix       # 自动发现 hosts/<username>@<platform>/
\`\`\`

## 模块命名

模块文件的路径只用于组织源码；对外注册的 aspect 名称统一采用小写 kebab-case；有明确功能域的模块统一使用 \`域.功能\` 点号分层，避免把域名和功能名用连字符拼在一起。聚合入口（如 \`programs\`、\`development\`、\`desktop.common\`）可以保留短名称。模块类保持 flake-parts 的标准名称（\`nixos\`、\`darwin\`、\`homeManager\`），模块名以注册声明为准。

## 桌面环境组合

桌面模块分为 NixOS 和 Home Manager 两个模块类，因为二者的选项系统不同。桌面入口可以负责把对应 HM 模块注入到 \`home-manager.users.<user>.imports\`，从而让主机只导入一个桌面入口，而不是分别导入 NixOS/HM 两份配置。

桌面入口只组合桌面所需能力。代理、数据库、开发工具等与桌面无关的服务应由主机或独立 profile 显式导入，避免切换桌面时意外启停服务。

## 主机与 nixpkgs 选择

主机目录名采用 \`<username>@<platform>\`，例如 \`mochou@nixos\`。主机发现和元数据集中维护在 \`modules/hosts.nix\`，分为两个独立映射：

- \`platforms\` 只描述输出类别（NixOS、Darwin 或 standalone Home Manager）和目标架构 \`system\`；
- \`packageSets\` 为每个平台分别指定系统层 \`nixpkgs\` input 和 Home Manager 的 \`homeManager\` input。

同一操作系统家族不需要因为 nixpkgs 来源不同而重复定义平台。需要支持另一架构时才新增 platform key，例如 \`darwin-aarch64\`。新增平台时必须同时登记平台元数据和包集映射；未登记的平台、缺失的包集或不存在的 flake input 都会在求值时直接报错。

当前策略：

| Platform | 系统 nixpkgs | Home Manager nixpkgs |
| --- | --- | --- |
| \`nixos\` / \`nixos-wsl\` | \`nixpkgs\`（unstable） | \`nixpkgs-stable\` |
| \`darwin\`（Intel） | \`nixpkgs-darwin\` | 跟随系统包集 |
| \`darwin-aarch64\` | \`nixpkgs\`（unstable） | 跟随系统包集 |
| \`wsl\`（standalone HM） | — | \`nixpkgs-stable\` |

NixOS 使用所选 nixpkgs input 的 \`lib.nixosSystem\` 构造系统；内嵌 Home Manager 保持 \`useGlobalPkgs = false\`，并通过 \`pkgsPath\` 使用独立选择的 nixpkgs source。Darwin 通过 nix-darwin 的 \`nixpkgs.source\` 选择系统包源，Home Manager 保持 \`useGlobalPkgs = true\`，跟随 Darwin 系统包集。Standalone Home Manager 则直接从 \`homeManager\` 指定的 input 导入 pkgs。

主机配置负责声明 \`nixpkgs.hostPlatform\`、磁盘、引导、网络等机器差异；\`system\` 是目标架构，不代表 nixpkgs 来源。通用功能应放在 \`modules/\`，不要复制到主机目录。不要使用 \`builtins.getEnv\` 隐式决定系统配置。

## 修改后检查

\`\`\`bash
nix fmt
nix flake check --no-build --impure --show-trace
nix eval '.#nixosConfigurations."mochou@nixos".config.programs.hyprland.enable'
\`\`\`

\`nix flake check --no-build\` 只做评估/检查，不代表系统闭包已经成功构建；实际部署前仍应执行对应主机的 build。
