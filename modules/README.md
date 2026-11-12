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
└── hosts.nix       # 自动发现 hosts/<username>@<platform>/
```

## 模块命名

模块文件的路径只用于组织源码；对外注册的 aspect 名称统一采用小写 kebab-case；有明确功能域的模块统一使用 `域.功能` 点号分层，避免把域名和功能名用连字符拼在一起。聚合入口（如 `programs`、`development`、`desktop.common`）可以保留短名称。模块类保持 flake-parts 的标准名称（`nixos`、`darwin`、`homeManager`），模块名以注册声明为准。例如：

```nix
self.modules.nixos."desktop.hyprland"
self.modules.homeManager."desktop.hyprland"
self.modules.nixos."services.proxy"
self.modules.homeManager.programs
self.modules.homeManager."programs.mpv"
self.modules.homeManager."programs.email"
self.modules.homeManager."services.ollama"
self.modules.homeManager."core.session-variables"
self.modules.homeManager."desktop.default-apps"
```

带点号的模块名必须作为单个属性名加引号；单段聚合名称可直接使用标识符。不要使用 `programs-mpv`、`services-ollama` 这类把域名与功能名混在一起的公开名称，也不要使用 `_default-apps` 这类临时名称。不要根据文件路径猜测模块名，应以对应文件中的 `flake.modules` 声明为准。

## 桌面环境组合

桌面模块分为 NixOS 和 Home Manager 两个模块类，因为二者的选项系统不同。桌面入口（例如 `desktop.hyprland` 的 NixOS 模块）可以负责把对应 HM 模块注入到 `home-manager.users.<user>.imports`，从而让主机只导入一个桌面入口，而不是分别导入 NixOS/HM 两份配置。

桌面入口只组合桌面所需能力。代理、数据库、开发工具等与桌面无关的服务应由主机或独立 profile 显式导入，避免切换桌面时意外启停服务。

## 主机约定

主机目录名采用 `<username>@<platform>`，例如 `mochou@nixos`。`modules/hosts.nix` 集中维护 platform 元数据，包括输出类别（NixOS、Darwin 或 standalone Home Manager）和包集架构 `system`；新增平台时必须登记，未登记的平台会在 flake 求值时直接报错，避免主机目录被静默忽略。一个 platform key 对应一种架构；同一 OS 家族需要支持另一架构时，新增明确的 platform key。Standalone Home Manager 使用该映射选择 nixpkgs，不再在主机组装逻辑中硬编码 `x86_64-linux`。主机配置负责：

- 声明 `nixpkgs.hostPlatform`、磁盘、引导、网络等机器差异；`pkgsSystem` 是包集架构元数据，不替代主机模块中的 `nixpkgs.hostPlatform`；
- 导入桌面入口和主机需要的服务；
- 声明硬件 profile 参数；
- 设置 Home Manager 用户目录及主机专属参数。

通用功能应放在 `modules/`，不要复制到主机目录。不要使用 `builtins.getEnv` 隐式决定系统配置；需要切换桌面时，应使用明确、可评估的 Nix 配置入口。

## 修改后检查

```bash
nix fmt
nix flake check --no-build --impure --show-trace
# host-evaluations 会评估所有 NixOS、Darwin 与 standalone Home Manager 主机
nix eval '.#nixosConfigurations."mochou@nixos".config.programs.hyprland.enable'
```

`nix flake check --no-build` 只做评估/检查，不代表系统闭包已经成功构建；实际部署前仍应执行对应主机的 build。
