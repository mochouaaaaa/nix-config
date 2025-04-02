{
  description = "Mochou's nix configuration for both NixOS & Nix & macOS";

  outputs = inputs: import ./outputs.nix inputs;
  # the nixConfig here only affects the flake itself, not the system configuration!
  nixConfig = {
    # for more information, see:
    #     https://nixos-and-flakes.thiscute.world/nix-store/add-binary-cache-servers
    # substituers will be appended to the default substituters when fetching packages
    extra-substituters = [
      "https://cache.nixos.org"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"

      "https://nix-gaming.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="

      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };

  inputs = {
    # Official NixOS package source, using nixos's unstable branch by default
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    systems.url = "github:nix-systems/default";
    impermanence.url = "github:nix-community/impermanence";

    flake-parts.url = "github:hercules-ci/flake-parts";

    # for macos
    nix-darwin.url = "github:LnL7/nix-darwin";

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/master";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    clipboard-sync.url = "github:dnut/clipboard-sync";

    # thmem
    stylix.url = "github:danth/stylix";
    honkai-railway-grub-theme.url = "github:voidlhf/StarRailGrubThemes";
    # keymap replaced
    xremap-flake.url = "github:xremap/nix-flake";
    # flatpak
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # generate iso/qcow2/docker/... image from nixos configuration
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";

    disko = {
      url = "github:nix-community/disko/v1.6.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # add git hooks to format nix code before commit
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nuenv.url = "github:DeterminateSystems/nuenv";

    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim = {
      url = "github:nix-community/neovim-nightly-overlay/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # desktop components
    waybar.url = "github:Alexays/Waybar/master";

    # hyprland or plugins
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hypr-dynamic-cursors = {
      url = "github:VirtCode/hypr-dynamic-cursors";
      inputs.hyprland.follows = "hyprland";
    };
    hyprlux = {
      url = "github:amadejkastelic/Hyprlux";
    };

    swww.url = "github:LGFae/swww";
    rofi-tools = {
      url = "github:szaffarano/rofi-tools";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    # kde
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };
}
