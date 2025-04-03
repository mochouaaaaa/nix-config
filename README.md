# Nix Starter Config

Nix Starter Config

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
