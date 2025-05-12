# Nix Starter Config

## Install

[nix installer](https://github.com/DeterminateSystems/nix-installer?tab=readme-ov-file#determinate-nix-installer)

## 目录结构

<details>
    <summary>目录结构</summary>

```txt
.
├── README.md
├── flake.lock
├── flake.nix                 // flake 源
├── hosts
│   ├── default.nix
│   ├── x86_64-darwin         // darwin x86_64架构
│   └── x86_64-linux          // linux x86_64架构,包含nixos和非nixos系统
├── lib
│   ├── attrs.nix
│   ├── default.nix
│   ├── macosSystem.nix       // darwin 配置入口
│   ├── nix.nix
│   ├── nixosSystem.nix       // nixos 配置入口
│   └── otherSystem.nix       // 非Nixos 配置入口
├── modules
│   ├── base.nix
│   ├── darwin                // darwin 系统配置
│   ├── default.nix
│   ├── home                  // home-manager 配置
│   └── nixos                 // nixos 系统配置
├── outputs.nix
├── templates
│   ├── default.nix
│   └── flake-parts
└── vars                      // 全局变量
    └── default.nix
```

</details>

## Usage

<details>
<summary>Macos Build</summary>

```bash
just switch
```

</details>

<details>
<summary>Linux Build</summary>

```bash
just ubuntu
```

</details>

<details>
<summary>Nixos Build</summary>

```bash
# desktop default `hyprlan`, `gnome`, `kde`, `niri`
just switch
```

</details>

## Image

<details>
<summary>Hyprland</summary>

![桌面](https://raw.githubusercontent.com/mochouaaaaa/issus_assert/master/quanping.png)

![截图剪切板](https://raw.githubusercontent.com/mochouaaaaa/issus_assert/master/jietu.png)

</details>

<details>
<summary>Gnome</summary>

![桌面](https://raw.githubusercontent.com/mochouaaaaa/issus_assert/master/desktop.png)

![apps](https://raw.githubusercontent.com/mochouaaaaa/issus_assert/master/app.png)

![panel](https://raw.githubusercontent.com/mochouaaaaa/issus_assert/master/panel.png)

</details>

<details>
<summary>KDE</summary>
![]
</details>
