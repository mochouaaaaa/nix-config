# Nix Starter Config

## Install

```bash

# curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate
# or

sh <(curl -L https://nixos.org/nix/install)
```

### Darwin

```base
nix profile install github:LnL7/nix-darwin

```

### Wsl

```bash
https://github.com/nix-community/NixOS-WSL
```

## Components

|                             | NixOS(Wayland)                                                                            |
| --------------------------- | ----------------------------------------------------------------------------------------- |
| **Window Manager**          | [Hyprland][Hyprland] / [Niri][Niri] / [Kde][Kde] / [Gnome][Gnome]                         |
| **Desktop Shell**           | [noctalia][noctalia] / [caelestia][caelestia] / [dankMaterial][dankMaterial]              |
| **Terminal Emulator**       | [Kitty][Kitty] / [Wezterm][Wezterm]                                                       |
| **Application Launcher**    | [vicinae][vicinae]                                                                        |
| **network management tool** | [NetworkManager][NetworkManager]                                                          |
| **Input method framework**  | [Fcitx5][Fcitx5] + [rime][rime] + [oh-my-rime][oh-my-rime] + [WanxiangGRAM][WanxiangGRAM] |
| **System resource monitor** | [Btop][Btop]                                                                              |
| **File Manager**            | [Yazi][Yazi] + [nautilus][nautilus]                                                       |
| **Shell**                   | [Zsh][Zsh] + [p10k][p10k]                                                                 |
| **Media Player**            | [mpv][mpv]                                                                                |
| **Text Editor**             | [Neovim][Neovim]                                                                          |
| **Fonts**                   | [Nerd fonts][Nerd fonts]                                                                  |
| **Image Viewer**            | [imv][imv] + [loupe][loupe]                                                               |
| **Screenshot Software**     | [grimblast][grimblast]                                                                    |
| **Screen Recording**        | [OBS][OBS] + [Kooha][Kooha]                                                               |

## Screenshot

![Hyprland](./asset/hyprland.png)

## ![Niri](./asset/niri.png)

## 目录结构

<details>
    <summary>目录结构</summary>

```bash
.
├── asset
├── config.nix
├── flake.lock
├── flake.nix
├── flake-parts
│   ├── darwin.nix                  # nix-darwin
│   ├── default.nix
│   ├── dev-shells                  # dev-shells
│   ├── home-manager.nix            # home-manager
│   ├── imports.nix                 # imports
│   ├── nixos.nix                   # nixos
│   ├── nix-settings.nix            # nix settings
│   └── packages.nix                # nixpkgs
├── hosts
│   ├── darwin.nix                  # darwin 系统配置入口
│   ├── default.nix
│   ├── nixos                       # nixos 主机配置,每个主机都不一样
│   ├── nixos.nix                   # nixos 系统配置入口
│   └── wsl.nix                     # wsl 配置入口
├── justfile                        # 一键部署脚本
├── modules
│   ├── darwin                      # darwin 系统配置
│   ├── default.nix
│   ├── home                        # home-manager 配置
│   │   ├── base
│   │   ├── darwin                  # home-manager darwin 配置
│   │   ├── default.nix
│   │   ├── linux                   # home-manager linux 配置
│   │   └── wsl                     # home-manager wsl 配置
│   ├── nixos                       # nixos 系统配置
│   │   ├── base
│   │   ├── default.nix
│   │   ├── desktop                 # nixos 桌面配置
│   │   ├── services                # nixos 服务相关配置
│   │   └── virtual                 # nixos 虚拟机配置
│   └── sharedModule                # darwin/linux 共享模块
│       ├── default.nix
│       ├── home-manager            # home-manager 共享模块不区分darwin/linux
│       └── os                      # os 共享模块不区分darwin/linux
├── nvfetcher.toml                  # 部分包pin版本
├── outputs.nix
├── overlays                        # nixpkgs overlays
│   ├── darwin.nix                  # darwin overlays
│   ├── default.nix
│   ├── home-manager.nix            # home-manager overlays
│   ├── nixos.nix                   # nixos overlays
│   └── pkgs
├── README.md
└── _sources
    ├── generated.json
    └── generated.nix
```

</details>

## Usage

<details>
<summary>Macos Build</summary>

```bash
# nix-darwin
just switch

# home-manager
just home-darwin
```

</details>

<details>
<summary>Linux Build</summary>

```bash
# linux
just home-hyprland # or home-gnome, home-kde, home-niri


```

</details>

<details>
<summary>Nixos Build</summary>

```bash
# nixos
just nixos-hyprland # or nixos-gnome, nixos-kde, nixos-niri

# home-manager
just home-hyprland # or home-gnome, home-kde, home-niri

```

</details>

<details>
<summary>Wsl Build</summary>

```bash
nix develop .#defailt
just swl
```

</details>

[Hyprland]: https://github.com/hyprwm/Hyprland
[Niri]: https://github.com/YaLTeR/niri
[Kde]: https://kde.org
[Gnome]: https://www.gnome.org
[noctalia]: https://github.com/noctalia-dev/noctalia-shell
[caelestia]: https://github.com/caelestia-dots/shell
[dankMaterial]: https://github.com/AvengeMedia/DankMaterialShell
[Kitty]: https://github.com/kovidgoyal/kitty
[Wezterm]: https://github.com/wezterm/wezterm
[Fcitx5]: https://github.com/fcitx/fcitx5
[rime]: https://rime.im
[oh-my-rime]: https://github.com/Mintimate/oh-my-rime
[Zsh]: https://www.zsh.org/
[p10k]: https://github.com/romkatv/powerlevel10k
[vicinae]: https://github.com/vicinaehq/vicinae
[WanxiangGRAM]: https://github.com/amzxyz/RIME-LMDG
[Btop]: https://github.com/aristocratos/btop
[mpv]: https://github.com/mpv-player/mpv
[imv]: https://sr.ht/~exec64/imv
[Neovim]: https://github.com/neovim/neovim
[loupe]: https://gitlab.gnome.org/GNOME/loupe
[OBS]: https://obsproject.com
[nautilus]: https://apps.gnome.org/zh-CN/Nautilus
[Yazi]: https://github.com/sxyazi/yazi
[Kooha]: https://github.com/SeaDve/Kooha
[grimblast]: https://github.com/hyprwm/contrib
[NetworkManager]: https://wiki.gnome.org/Projects/NetworkManager
[Nerd fonts]: https://github.com/ryanoasis/nerd-fonts
