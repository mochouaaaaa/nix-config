# 桌面模块

本目录组织桌面会话、系统桌面基础能力和桌面组件。桌面入口是 NixOS 模块，并为 Host 主用户组合对应的 Home Manager 模块。

## 当前桌面入口

| NixOS 模块 ID | Home Manager 模块 ID | 桌面会话 |
| --- | --- | --- |
| `desktop.hyprland` | `desktop.hyprland` | Hyprland |
| `desktop.niri` | `desktop.niri` | Niri |
| `desktop.kde` | `desktop.kde` | KDE Plasma |
| `desktop.cosmic` | `desktop.cosmic` | COSMIC |
| `desktop.umbriel` | `desktop.umbriel` | Umbriel |

上述入口均导入 NixOS 模块 `desktop.common`，并只为 Host 主用户导入对应的 Home Manager 桌面模块。NixOS 与 Home Manager 仍属于不同模块类；此处的组合不会自动作用于其他 Home Manager 用户。

桌面入口负责会话本身及其必要的登录管理器配置。登录管理器和自动登录行为以对应入口及 Host 配置为准，不应从其他桌面入口推断。

## 公共基础模块

| 模块 ID | 模块类 | 职责 |
| --- | --- | --- |
| `desktop.common` | NixOS + Home Manager | 兼容性组合入口：NixOS 侧导入 `desktop.base`、`desktop.hardware`，并为主用户导入 Home Manager 的 `desktop.common`。 |
| `desktop.base` | NixOS | 桌面系统基础能力，包括外观、安全、地理位置、UWSM 与 XDG Portal 基础配置。 |
| `desktop.hardware` | NixOS | 导入通用硬件模块与 `hardware.desktop`，并配置图形桌面用户所需的设备组。 |
| `desktop.user` | Home Manager | 用户桌面基础设置，包括输入法、外观、快捷键和 Vicinae 启动器。 |

底层模块可以独立导入。需要精简桌面组合的 Host 可直接选择 `desktop.base`、`desktop.hardware` 和 `desktop.user`，而不是使用兼容性组合入口。

## 独立桌面组件

| 模块 ID | 模块类 | 用途 |
| --- | --- | --- |
| `desktop.greeter.noctalia` | NixOS | Noctalia Greeter 登录界面集成。 |
| `desktop.shell.noctalia` | Home Manager | Noctalia 桌面 Shell，由需要它的桌面会话显式导入。 |
| `desktop.launcher.vicinae` | Home Manager | Vicinae 启动器及按键映射。 |
| `desktop.flatpak` | NixOS + Home Manager | Flatpak 系统侧支持与用户级客户端组合。 |

Greeter、Shell 和 Launcher 是不同组件，不会因为选择其中一个而自动启用其他组件。具体哪些桌面入口组合 Noctalia，应以对应的 NixOS 和 Home Manager 模块为准。

## 桌面应用

可选图形应用与桌面会话分开管理，应用模块位于 `modules/programs/desktop/`，由 Host 或 Home Manager 角色按需导入。

应用分组、聚合入口及数据库客户端见 [程序模块说明](../programs/README.md)。桌面会话不应通过应用聚合入口启用。

## 边界

- 桌面会话及其必要的系统集成放在本目录。
- 用户级应用放在 `modules/programs/desktop/`。
- 通用硬件能力放在 `modules/hardware/`。
- 代理、数据库和其他主机服务放在 `modules/services/`，由 Host 显式选择。
- 开发语言与 IDE 工具放在 `modules/development/`。

新增桌面入口时，应同时明确 NixOS 与 Home Manager 两侧的职责，并避免将与桌面会话无关的服务隐式加入公共入口。