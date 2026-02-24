{
  description = "Mochou's nix configuration for both NixOS & Nix & macOS";

  outputs = inputs: import ./outputs.nix inputs;
  # the nixConfig here only affects the flake itself, not the system configuration!

  # the nixConfig here only affects the flake itself, not the system configuration!
  # for more information, see:
  #     https://nixos-and-flakes.thiscute.world/nix-store/add-binary-cache-servers
  nixConfig = {
    extra-substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=10"
      # "https://nix-mirror.freetls.fastly.net?priority=11"
      "https://cache.nixos.org?priority=12"
      "https://nix-community.cachix.org?priority=13"
      "https://niri.cachix.org"
      "https://hyprland.cachix.org"
      "https://mochouaaaaa.cachix.org"
    ];

    extra-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "mochouaaaaa.cachix.org-1:/enIIKfFu959KLIDs0OOHBd9EjnMt53b62Jr2oatV34="
    ];
  };

  inputs = {
    # Official NixOS package source, using nixos's unstable branch by default
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-os.url = "github:nixos/nixpkgs/nixos-25.11";
    systems.url = "github:nix-systems/default";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    agenix.url = "github:ryantm/agenix";
    nixd = {
      url = "github:nix-community/nixd";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles = {
      url = "github:mochouaaaaa/dotfile/nvim-fzf";
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
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    # for wsl
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # for linux
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

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

    nixvim = {
      url = "github:nix-community/nixvim";
    };
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    # desktop components
    vicinae = {
      url = "github:vicinaehq/vicinae?ref=v0.19.9";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # desktop-shell
    caelestia-shell = {
      url = "github:caelestia-dots/shell?ref=v1.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell";
    };
    noctalia = {
      # url = "/home/mochou/Code/Projects/c/noctalia-shell";
      # url = "github:noctalia-dev/noctalia-shell?ref=v4.4.0";
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    DankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell?ref=v1.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprland
    hyprutils.url = "github:hyprwm/hyprutils?ref=v0.11.0";
    hyprgraphics.url = "github:hyprwm/hyprgraphics";
    aquamarine.url = "github:hyprwm/aquamarine";
    hyprlang.url = "github:hyprwm/hyprlang?ref=v0.6.8";
    hyprshutdown.url = "github:hyprwm/hyprshutdown";
    hyprland = {
      url = "github:hyprwm/Hyprland?ref=v0.53.1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        hyprutils.follows = "hyprutils";
        hyprgraphics.follows = "hyprgraphics";
        aquamarine.follows = "aquamarine";
        hyprlang.follows = "hyprlang";
      };
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # niri
    xwayland-satellite = {
      url = "github:Supreeeme/xwayland-satellite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      # url = "github:sodiboo/niri-flake";
      url = "github:sodiboo/niri-flake?ref=very-refactor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.xwayland-satellite-unstable.follows = "xwayland-satellite";
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
}
