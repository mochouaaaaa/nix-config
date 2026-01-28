
set shell := ["bash", "-cu"]
NH_HOSTNAME := "$USER@$(hostname)"
NH_BUILD_ARGS := "-- --impure"
NH_OS_FLAKE := "$(pwd)"
NH_HOME_FLAKE := "$(pwd)"
NH_DARWIN_FLAKE := "$(pwd)"
PRE_ARGS := "NIXPKGS_ALLOW_INSECURE=1"

# help
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
    nix flake update nixpkgs nixpkgs-stable systems flake-parts home-manager

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
switch:
    # NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 darwin-rebuild switch --flake .#mochou@darwin --impure
    {{ PRE_ARGS }} nh darwin switch {{ NH_DARWIN_FLAKE }} -H {{ NH_HOSTNAME }} {{ NH_BUILD_ARGS }}

# switch home-manager config
[macos]
home-darwin:
    # home-manager switch --flake .#mochou@darwin --impure -b backup
    {{ PRE_ARGS }} nh home switch {{ NH_HOME_FLAKE }} -c {{ NH_HOSTNAME }} {{ NH_BUILD_ARGS }}

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
    nix flake update impermanence nixos-generators grub2-themes nix-flatpak xremap-flake

[linux]
_reset_dconf:
    dconf reset -f /org/gnome/

# Wsl switch config
[linux]
@wsl:
    if [ -e /proc/sys/fs/binfmt_misc/WSLInterop ]; then NIXPKGS_ALLOW_INSECURE=1 sudo -E nixos-rebuild switch --flake .#mochou@wsl --impure; fi

# build nixos boot
[linux]
boot desktop="hyprland":
    DESKTOP={{ desktop }} {{ PRE_ARGS }} nh os boot {{ NH_OS_FLAKE }} -H {{ NH_HOSTNAME }} {{ NH_BUILD_ARGS }}

# restart home-manager
[linux]
@home-manager-restart:
    sudo systemctl restart home-manager-$(whoami).service

# switch flake config
[linux]
switch desktop="hyprland":
    DESKTOP={{ desktop }} {{ PRE_ARGS }} nh os switch {{ NH_OS_FLAKE }} -H {{ NH_HOSTNAME }} {{ NH_BUILD_ARGS }}

# repl test environment
[linux]
repl desktop="hyprland":
    NIXPKGS_ALLOW_INSECURE=1 DESKTOP={{ desktop }} nixos-rebuild repl --flake .#{{ NH_HOSTNAME  }} --impure

# switch hyprland desktop environment
[linux]
[group('nixos desktop')]
nixos-hyprland:
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
    # nix flake update niri
    just switch niri

[linux]
[group('home-manager')]
home-repl desktop="hyprland":
    NIXPKGS_ALLOW_INSECURE=1 DESKTOP={{ desktop }} nix repl . --impure

# switch hyprland desktop environment
[linux]
[group('home-manager')]
home-hyprland:
    DESKTOP=hyprland {{ PRE_ARGS }} nh home switch {{ NH_HOME_FLAKE }} -b backup {{ NH_BUILD_ARGS }}


# switch kde desktop environment
[linux]
[group('home-manager')]
home-kde:
    DESKTOP=kde {{ PRE_ARGS }} nh home switch{{ NH_HOME_FLAKE }} -b backup {{ NH_BUILD_ARGS }}

# switch gnome desktop environment
[linux]
[group('home-manager')]
home-gnome:
     DESKTOP=gnome {{ PRE_ARGS }} nh home switch {{ NH_HOME_FLAKE }} -b backup {{ NH_BUILD_ARGS }}


# switch nir desktop environment
[linux]
[group('home-manager')]
home-niri:
    DESKTOP=niri {{ PRE_ARGS }} nh home switch {{ NH_HOME_FLAKE }} -b backup {{ NH_BUILD_ARGS }}


