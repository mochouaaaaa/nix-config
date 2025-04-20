
set shell := ["bash", "-cu"]


default:
    @just --list
    

[group('nix')]
fmt:
  # format the nix files in this repo
  nix fmt

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

#-------------------------------
# MacOS 环境
#-------------------------------

[macos]
@update:
    nix flake update nix-darwin nixpkgs nixpkgs-stable nixpkgs-unstable nixpkgs-darwin home-manager

[macos]
@switch:
    darwin-rebuild switch --flake .#macos --impure --option substituters "https://mirrors.cernet.edu.cn/nix-channels/store"

[macos]
@repl:
    nix repl -f .#macos


#-------------------------------
# NixOS 环境
#-------------------------------

# flake update
[linux]
@update:
    nix flake update nixpkgs nixpkgs-stable nixpkgs-unstable nixpkgs-linux home-manager

# switch flake config
[linux]
switch desktop="hyprland":
    HOME=/root DESKTOP={{ desktop }} sudo -E nixos-rebuild switch --flake .#nixos --impure --option substituters "https://mirrors.cernet.edu.cn/nix-channels/store"

# repl test environment
[linux]
@repl desktop="hyprland":
    HOME=/root DESKTOP={{ desktop }} sudo -E nixos-rebuild repl --flake .#nixos --impure

[linux]
[group('nixos desktop')]
@hyprland:
    just switch

[linux]
[group('nixos desktop')]
@kde:
    just switch kde

[linux]
[group('nixos desktop')]
@gnome:
    just switch gnome

[linux]
[group('nixos desktop')]
@niri:
    just switch niri

# 非 NixOS 系统
[linux]
[group('not nixos')]
@ubuntu:
    home-manager switch --flake .#ubuntu --impure --option substituters "https://mirrors.cernet.edu.cn/nix-channels/store"

