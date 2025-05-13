
set shell := ["bash", "-cu"]


default:
    @just --list
    

# format the nix files in this repo
[group('nix')]
fmt:
    nix fmt .

# nix store garbage collection
[group('nix')]
gc:
    sudo nix-collect-garbage -d
    nix-collect-garbage -d

# Show all the auto gc roots in the nix store
[group('nix')]
gcroot:
    ls -al /nix/var/nix/gcroots/auto/


# Verify all the store entries
# Nix Store can contains corrupted entries if the nix store object has been modified unexpectedly.
# This command will verify all the store entries,
# and we need to fix the corrupted entries manually via `sudo nix store delete <store-path-1> <store-path-2> ...`
[group('nix')]
verify-store:
    nix store verify --all


[group('flake')]
_update:
    nix flake update nixpkgs nixpkgs-unstable nixpkgs-stable systems flake-parts home-manager

#-------------------------------
# MacOS 环境
#-------------------------------

# flake update
[macos]
update:
    just _update
    nix flake update nix-darwin nixpkgs-darwin 

# switch flake config
[macos]
switch:
    darwin-rebuild switch --flake .#macos --impure --option substituters "https://mirrors.cernet.edu.cn/nix-channels/store"

# repl test environment
[macos]
@repl:
    nix repl .


#-------------------------------
# NixOS 环境
#-------------------------------

# flake update
[linux]
update:
    just _update
    nix flake update impermanence nixos-generators grub2-themes nix-flatpak xremap-flake clipboard-sync

[linux]
_reset_dconf:
    dconf reset -f /org/gnome/

# switch flake config
[linux]
switch desktop="hyprland":
    just _reset_dconf
    HOME=/root DESKTOP={{ desktop }} sudo -E nixos-rebuild switch --flake .#nixos --impure --option substituters "https://mirrors.cernet.edu.cn/nix-channels/store"

# repl test environment
[linux]
@repl desktop="hyprland":
    HOME=/root DESKTOP={{ desktop }} sudo -E nixos-rebuild repl --flake .#nixos --impure

# switch hyprland desktop environment
[linux]
[group('nixos desktop')]
@hyprland:
    nix flake update rofi-tools swww hyprlux waybar
    just switch

# switch kde desktop environment
[linux]
[group('nixos desktop')]
@kde:
    nix flake update plasma-manager
    just switch kde

# switch gnome desktop environment
[linux]
[group('nixos desktop')]
@gnome:
    just switch gnome

# switch niri desktop environment
[linux]
[group('nixos desktop')]
@niri:
    just switch niri

# home-manager ubuntu gnome environment
[linux]
[group('home-manager')]
ubuntu:
    home-manager switch --flake .#ubuntu --impure --option substituters "https://mirrors.cernet.edu.cn/nix-channels/store"

