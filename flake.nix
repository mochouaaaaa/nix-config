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
      "https://mirrors.ustc.edu.cn/nix-channels/store"

      "https://yazi.cachix.org"
      "https://nix-gaming.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="

      "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };

  inputs = {
    # Official NixOS package source, using nixos's unstable branch by default
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    systems.url = "github:nix-systems/default";
    impermanence.url = "github:nix-community/impermanence";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    # for macos
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # keymap replaced
    xremap-flake.url = "github:xremap/nix-flake";
    # flatpak
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
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

    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    neovim = {
      url = "github:nix-community/neovim-nightly-overlay/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yazi.url = "github:sxyazi/yazi";

    # desktop components
    clipboard-sync.url = "github:dnut/clipboard-sync";
    waybar.url = "github:Alexays/Waybar/master";

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
