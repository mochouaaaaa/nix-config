# 桌面模块

本目录组织桌面会话、系统桌面基础能力和桌面组件。仓库自有配置统一定义为 flake Aspect，并通过 includes 声明同 class 组合关系。

## 桌面会话

桌面会话的实现统一位于 `modules/desktop/sessions/`。这里的 `sessions` 同时涵盖 Wayland compositor 与完整桌面环境，避免将 KDE、COSMIC 等桌面环境误称为 compositor。

| Aspect ID | NixOS class | Home Manager class | 桌面会话 |
| --- | --- | --- | --- |
| desktop.hyprland | NixOS | Home Manager | Hyprland |
| desktop.niri | NixOS | Home Manager | Niri |
| desktop.kde | NixOS | Home Manager | KDE Plasma |
| desktop.cosmic | NixOS | Home Manager | COSMIC |
| desktop.umbriel | NixOS | Home Manager | Umbriel |

桌面 Aspect 的 NixOS 与 Home Manager 配置属于不同 class。Host 负责选择桌面能力；Aspect 内的 includes 负责声明同 class 依赖。外部 flake 提供的模块（例如 Plasma Manager、COSMIC Manager、Luciole）仍通过普通 imports 引入。

Hyprland 和 Niri 还包含依赖 NixOS compositor 配置的 Home Manager 兼容设置。这些设置保留在对应的 NixOS Aspect 中；桌面主体配置则由 Host 选择的桌面 Aspect 提供。

## 公共基础能力

| Aspect ID | Class | 职责 |
| --- | --- | --- |
| desktop.common | NixOS + Home Manager | 组合 desktop.base、desktop.hardware，并在 Home Manager class 中组合用户桌面基础配置。 |
| desktop.base | NixOS | 桌面系统基础能力，包括外观、安全、AppImage 运行时、地理位置、UWSM、XDG Portal、图形与电源服务。 |
| desktop.hardware | NixOS | 组合通用硬件模块与 hardware.desktop，并配置图形桌面用户所需的设备组。 |
| desktop.user | Home Manager | 用户桌面基础设置，组合输入法、外观、快捷键和 Vicinae 启动器。 |
| desktop.default-apps | Home Manager | 默认 MIME 应用及文档查看器、归档管理器，由需要它的桌面会话显式组合。 |
| desktop.nautilus | NixOS | Nautilus、GVFS 与缩略图支持，由需要它的桌面会话显式组合。 |
| desktop.keyring | NixOS | GNOME Keyring 基础服务，由需要它的桌面会话显式组合。 |

## 独立桌面组件

| Aspect ID | Class | 用途 |
| --- | --- | --- |
| desktop.greeter.noctalia | NixOS | Noctalia Greeter 登录界面集成。 |
| desktop.shell.noctalia | Home Manager | Noctalia 桌面 Shell，由需要它的 compositor Aspect 显式组合。 |
| desktop.launcher.vicinae | Home Manager | Vicinae 启动器、扩展及用户级配置，由 desktop.user 组合。 |
| desktop.flatpak | NixOS + Home Manager | Flatpak 系统侧支持与用户级客户端组合。 |

Greeter、Shell 和 Launcher 是不同组件，不会因为选择其中一个而自动启用其他组件。

## 桌面应用

可选图形应用与桌面会话分开管理。通用独立图形应用（例如通信、邮件、安全、办公、笔记、媒体、远程桌面和数据库客户端）位于 `modules/programs/desktop/`，并按 `communication/`、`email/`、`security/`、`notes/`、`remote/` 等用途分组。浏览器、编辑器、媒体播放器、终端和输入法等具有独立配置域的程序，仍分别位于 `modules/programs/` 下对应的功能目录。

`desktop.programs.*` Aspect 提供应用分组和聚合入口。数据库客户端 `desktop.programs.database` 由工作站角色单独组合，不属于完整桌面应用聚合入口。桌面会话不应通过应用聚合入口启用。

## 边界

- 桌面会话及其必要的系统集成放在本目录。
- 通用独立图形应用放在 `modules/programs/desktop/`；浏览器、编辑器、媒体播放器、终端和输入法保留在各自的程序功能目录。
- 通用硬件能力放在 `modules/hardware/`。
- 代理、数据库和其他主机服务放在 `modules/services/`，由 Host 显式选择。
- 开发语言与 IDE 工具放在 `modules/development/`。
- Preservation 规则以独立 NixOS Aspect 注册，按实际启用状态决定是否持久化数据。
