
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
@update:
    just _update
    nix flake update nix-darwin nixpkgs-darwin 

# switch nix-darwin config
[macos]
@switch:
    NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 sudo -E darwin-rebuild switch --flake .#mochou@darwin --impure

# switch home-manager config
[macos]
@home-darwin:
    home-manager switch --flake .#mochou@darwin --impure -b backup

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
    NIXPKGS_ALLOW_INSECURE=1 HOME=/root DESKTOP={{ desktop }} sudo -E nixos-rebuild switch --flake .#mochou@nixos --impure

# repl test environment
[linux]
@repl desktop="hyprland":
    NIXPKGS_ALLOW_INSECURE=1 HOME=/root DESKTOP={{ desktop }} sudo -E nixos-rebuild repl --flake .#mochou@nixos --impure

# switch hyprland desktop environment
[linux]
[group('nixos desktop')]
@nixos-hyprland:
    nix flake update hypr-dynamic-cursors hyprland-plugins rofi-tools swww hyprlux waybar
    just switch

# switch kde desktop environment
[linux]
[group('nixos desktop')]
@nixos-kde:
    nix flake update plasma-manager
    just switch kde

# switch gnome desktop environment
[linux]
[group('nixos desktop')]
@nixos-gnome:
    just switch gnome

# switch niri desktop environment
[linux]
[group('nixos desktop')]
@nixos-niri:
    nix flake update niri
    just switch niri

[linux]
[group('home-manager')]
@home-repl desktop="hyprland":
    NIXPKGS_ALLOW_INSECURE=1 DESKTOP={{ desktop }} nix repl .

# switch hyprland desktop environment
[linux]
[group('home-manager')]
@home-hyprland:
    # nix flake update rofi-tools swww hyprlux waybar
    NIXPKGS_ALLOW_INSECURE=1 DESKTOP=hyprland home-manager switch --flake .#mochou@nixos --impure -b backup

# switch kde desktop environment
[linux]
[group('home-manager')]
@home-kde:
    NIXPKGS_ALLOW_INSECURE=1  DESKTOP=kde home-manager switch --flake .#mochou@nixos --impure -b backup

# switch gnome desktop environment
[linux]
[group('home-manager')]
@home-gnome:
    NIXPKGS_ALLOW_INSECURE=1 DESKTOP=gnome home-manager switch --flake .#mochou@nixos --impure -b backup

# switch nir desktop environment
[linux]
[group('home-manager')]
@home-niri:
    NIXPKGS_ALLOW_INSECURE=1 DESKTOP=niri home-manager switch --flake .#mochou@nixos --impure -b backup

