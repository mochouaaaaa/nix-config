{
  description = "Mochou's nix configuration for both NixOS & Nix & macOS";

  # nixConfig here affects flake evaluation and fetching, not the deployed system settings.
  # for more information, see:
  #     https://nixos-and-flakes.thiscute.world/nix-store/add-binary-cache-servers
  nixConfig = {
    extra-substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=10"
      "https://mirrors.ustc.edu.cn/nix-channels/store?priority=11"

      # "https://nix-mirror.freetls.fastly.net?priority=11"
      "https://cache.nixos.org?priority=20"
      "https://nix-community.cachix.org?priority=21"

      # "https://niri.cachix.org?priority=40"
      # "https://hyprland.cachix.org?priority=40"
      # "https://mochouaaaaa.cachix.org?priority=11"
    ];

    extra-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      # "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      # "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      # "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      # "mochouaaaaa.cachix.org-1:/enIIKfFu959KLIDs0OOHBd9EjnMt53b62Jr2oatV34="
    ];
  };

  inputs = {
    # Official NixOS package source, using nixos's unstable branch by default
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    systems.url = "github:nix-systems/default";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    git-hooks-nix.url = "github:cachix/git-hooks.nix";

    agenix.url = "github:ryantm/agenix";
    agenix-rekey.url = "github:oddlama/agenix-rekey";

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles = {
      url = "github:mochouaaaaa/dotfile/0.12";
      flake = false;
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mochou_nur = {
      url = "github:mochouaaaaa/nur-packages";
    };

    # for macos
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    # for wsl
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # for linux
    apple-emoji-font.url = "github:zhdsmy/apple-emoji";
    # spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    # nix-jetbrains-plugins.url = "github:nix-community/nix-jetbrains-plugins";

    # keymap replaced
    xremap-flake.url = "github:xremap/nix-flake";

    preservation = {
      url = "github:nix-community/preservation";
    };

    # generate iso/qcow2/docker/... image from nixos configuration
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/v1.11.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # flatpak
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        # home-manager.follows = "home-manager";
      };
    };

    # desktop components
    dank-material-shell = {
      url = "github:AvengeMedia/DankMaterialShell?ref=v1.4.4";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # kde
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    mysecrets = {
      url = "git+ssh://git@github.com/mochouaaaaa/secrets.git?shallow=1";
      flake = false;
    };

  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.flake-parts.flakeModules.modules
        inputs.home-manager.flakeModules.home-manager

        (inputs.import-tree ./modules)
      ];

    };

}
