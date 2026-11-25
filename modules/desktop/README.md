# 桌面模块组合

桌面入口是 NixOS 模块，负责将系统侧桌面环境与 Host 主用户对应的 Home Manager 模块组合起来。除非有明确的多桌面环境需求，否则每个 Host 应只选择一个桌面入口。

## 桌面入口

| NixOS 模块 ID | Home Manager 模块 ID | 会话 |
| --- | --- | --- |
| `desktop.hyprland` | `desktop.hyprland` | Hyprland |
| `desktop.niri` | `desktop.niri` | Niri |
| `desktop.gnome` | `desktop.gnome` | GNOME |
| `desktop.kde` | `desktop.kde` | KDE Plasma |

每个入口都会导入 `desktop.common`，并且只将对应的 Home Manager 模块加入 `home-manager.users.<username>.imports`。NixOS 与 Home Manager 仍属于不同的模块类；这里的组合仅作用于 Host 的主用户，不会自动作用于所有 Home Manager 用户。

Hyprland 和 Niri 还会导入 Noctalia Greeter 组件。GNOME 使用 GDM，KDE 使用 SDDM。自动登录由 Host 自己配置，不在桌面入口中隐式启用。

## 公共组件

| 模块 ID | 模块类 | 职责 |
| --- | --- | --- |
| `desktop.common` | NixOS + Home Manager | 兼容性聚合入口；为现有桌面入口组合 `desktop.base`、`desktop.hardware` 和 `homeManager.desktop.user`。 |
| `desktop.base` | NixOS | 桌面系统基础能力：外观、桌面安全、地理位置、UWSM、XDG Portal、打印、电源服务、X Server 默认值、图形集成及相关兼容设置。 |
| `desktop.hardware` | NixOS | 通用硬件配置，以及包含音频和蓝牙的 `hardware.desktop` 组合。 |
| `homeManager.desktop.user` | Home Manager | 用户桌面设置：Rime、外观、快捷键、Vicinae、光标、XDG 用户目录和 Portal 默认值、MPRIS、Neovide Wayland 集成。 |
| `desktop.greeter.noctalia` | NixOS | Hyprland 和 Niri 使用的 Noctalia Greeter 集成。 |
| `desktop.shell.noctalia` | Home Manager | Noctalia 桌面 Shell 配置，拆分为多个专注于单一职责的组件模块。 |
| `desktop.launcher.vicinae` | Home Manager | Vicinae 启动器配置和按键映射。 |
| `desktop.flatpak` | NixOS + Home Manager | 显式的用户级 Flatpak 客户端集成，以及 NixOS 到 Home Manager 的模块组合。 |

普通桌面 Host 继续导入 `desktop.common`。需要更精简组合的 Host 可以分别导入 `desktop.base` 和/或 `desktop.hardware`；需要用户级桌面设置时，再将 `homeManager.desktop.user` 加入目标 Home Manager 用户的 imports。底层原子模块始终可以独立使用，兼容性聚合入口不会取代它们。

Noctalia Shell 与 Greeter 是两个独立组件。桌面入口只在需要时选择 Greeter；Shell 则由相应的 Home Manager 配置独立组合。

代理、数据库等 Host 专属服务不属于桌面基础能力，应由 Host 或专用角色显式导入。KVM 调优仍通过硬件 profile 按需启用。

## 桌面应用配置组

可选图形应用与桌面会话独立选择，其 Home Manager 模块 ID 注册在 `desktop.programs.*` 下：

- `desktop.programs.api-clients`
- `desktop.programs.browsers`
- `desktop.programs.audio`
- `desktop.programs.security`
- `desktop.programs.communication`
- `desktop.programs.email`
- `desktop.programs.media`
- `desktop.programs.notes`
- `desktop.programs.remote`
- `desktop.programs.office`

兼容性聚合入口 `desktop.programs` 位于 `modules/programs/desktop/profiles.nix`，会导入上面列出的 Home Manager 应用组。Host 也可以只导入实际需要的分组。

网络集成是独立模块：`desktop.programs.networking` 只注册为 NixOS 和 Darwin 模块，因此必须通过对应的系统模块类导入，不能作为 Home Manager 模块导入。

数据库客户端单独注册为 `desktop.programs.database`，不包含在兼容性聚合入口中。API 客户端组当前包含 Hoppscotch，以及非 Darwin 平台上的 Cartero。

桌面会话本身由 `modules/desktop/` 配置，而不是由本目录的应用 profile 配置。详见 [桌面模块目录说明](../desktop/README.md)。

## 服务与平台边界

系统服务模块位于 `modules/services/`，使用 `services.proxy`、`services.mysql`、`services.virtualisation.qemu` 等功能 ID，不会因为启用桌面 profile 而自动开启。

系统服务和合成器/会话集成使用 `nixos` 模块类；用户级应用设置使用 `homeManager` 模块类。程序的平台差异应放在对应的 Linux、Darwin、NixOS 或 nix-darwin 模块中。
