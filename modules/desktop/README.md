# 桌面模块

本目录组织桌面会话、系统桌面基础能力和桌面组件。可复用的 NixOS 与 Home Manager 配置优先定义为 flake Aspect，并通过 `includes` 声明组合关系；只有跨类桥接、兼容入口和 Preservation 聚合仍保留普通模块。

## 桌面会话

| Aspect ID | NixOS class | Home Manager class | 桌面会话 |
| --- | --- | --- | --- |
| `desktop.hyprland` | NixOS | Home Manager | Hyprland |
| `desktop.niri` | NixOS | Home Manager | Niri |
| `desktop.kde` | NixOS | Home Manager | KDE Plasma |
| `desktop.cosmic` | NixOS | Home Manager | COSMIC |
| `desktop.umbriel` | NixOS | Home Manager | Umbriel |

桌面 Aspect 的 NixOS 与 Home Manager 配置属于不同 class，不会自动跨 class 传播。NixOS 侧只为 Host 主用户显式桥接对应的 Home Manager 模块；外部 flake 提供的模块（例如 Plasma Manager、COSMIC Manager、Luciole）仍通过普通 `imports` 引入。

桌面入口负责会话本身及其必要的登录管理器配置。登录管理器和自动登录行为以对应入口及 Host 配置为准，不应从其他桌面入口推断。

## 公共基础能力

| Aspect ID | Class | 职责 |
| --- | --- | --- |
| `desktop.common` | NixOS | 组合 `desktop.base` 与 `desktop.hardware`，并为主用户桥接 Home Manager 兼容入口。 |
| `desktop.base` | NixOS | 桌面系统基础能力，包括外观、安全、地理位置、UWSM、XDG Portal、图形与电源服务。 |
| `desktop.hardware` | NixOS | 组合通用硬件模块与 `hardware.desktop`，并配置图形桌面用户所需的设备组。 |
| `desktop.user` | Home Manager | 用户桌面基础设置，组合输入法、外观、快捷键和 Vicinae 启动器。 |
| `desktop.default-apps` | Home Manager | 默认 MIME 应用及文档查看器、归档管理器，由需要它的桌面会话显式组合。 |
| `desktop.nautilus` | NixOS | Nautilus、GVFS 与缩略图支持，由 Hyprland 和 Niri 显式组合。 |
| `desktop.keyring` | NixOS | GNOME Keyring 基础服务，由 Hyprland 和 Niri 显式组合。 |

`desktop.common` 的 Home Manager 同名入口仍是普通兼容模块，用于显式桥接 `desktop.user`；它不是 NixOS Aspect 的跨 class 自动传播。需要精简桌面组合的 Host 可直接选择 `desktop.base`、`desktop.hardware` 和 `desktop.user`，而不是使用兼容性组合入口。

## 独立桌面组件

| Aspect ID | Class | 用途 |
| --- | --- | --- |
| `desktop.greeter.noctalia` | NixOS | Noctalia Greeter 登录界面集成，由 Hyprland、Niri 和 Umbriel 显式组合。 |
| `desktop.shell.noctalia` | Home Manager | Noctalia 桌面 Shell，由需要它的 compositor Aspect 显式组合。 |
| `desktop.launcher.vicinae` | Home Manager | Vicinae 启动器、扩展及用户级配置，由 `desktop.user` 组合。 |
| `desktop.flatpak` | NixOS + Home Manager | Flatpak 系统侧支持与用户级客户端组合。 |

Greeter、Shell 和 Launcher 是不同组件，不会因为选择其中一个而自动启用其他组件。Umbriel 另外通过普通 `imports` 引入外部 Luciole 模块。

## 桌面应用

可选图形应用与桌面会话分开管理，应用模块位于 `modules/programs/desktop/`，由 Host 或 Home Manager 角色按需导入。

本目录的 `desktop.programs.*` Aspect 提供 API 与数据库客户端配置。应用分组、聚合入口及其他数据库客户端见 [程序模块说明](../programs/README.md)。桌面会话不应通过应用聚合入口启用。

## 边界

- 桌面会话及其必要的系统集成放在本目录。
- 用户级应用放在 `modules/programs/desktop/`。
- 通用硬件能力放在 `modules/hardware/`。
- 代理、数据库和其他主机服务放在 `modules/services/`，由 Host 显式选择。
- 开发语言与 IDE 工具放在 `modules/development/`。
- Preservation 规则仍注册为独立 NixOS 模块，按实际启用状态决定是否持久化数据。

新增桌面入口时，应同时明确 NixOS 与 Home Manager 两侧的职责，并通过 Aspect `includes` 声明同 class 的依赖；跨 class 的 Home Manager 配置必须由 NixOS 侧显式桥接。
