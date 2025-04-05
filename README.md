# Nix Starter Config

## Install

[nix installer](https://github.com/DeterminateSystems/nix-installer?tab=readme-ov-file#determinate-nix-installer)

## Usage

<details>
<summary>Macos Build</summary>

```bash
darwin-rebuild switch --flake .#macos --impure
```

</details>

<details>
<summary>Linux Build</summary>

```bash
home-manager switch --flake .#ubuntu --impure
```

</details>

<details>
<summary>Nixos Build</summary>

```bash
nixos-rebuild switch --flake .#nixos --impure
```

</details>

## Image

<details>
<summary>Hyprland</summary>
![]
</details>
