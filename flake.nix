{
  description = "Mochou's nix configuration for both NixOS & Nix & macOS";

  # nixConfig here affects flake evaluation and fetching, not the deployed system settings.
  # for more information, see:
  #     https://nixos-and-flakes.thiscute.world/nix-store/add-binary-cache-servers
  nixConfig = {
    extra-substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=10"
      "https://mirrors.ustc.edu.cn/nix-channels/store?priority=11"

      "https://cache.nixos.org?priority=20"
      "https://nix-community.cachix.org?priority=21"
    ];

    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    # Official NixOS package source, using nixos's unstable branch by default
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    git-hooks-nix.url = "github:cachix/git-hooks.nix";

    agenix.url = "github:ryantm/agenix";
    agenix-rekey.url = "github:oddlama/agenix-rekey";

    dotfiles = {
      url = "github:mochouaaaaa/dotfile/master";
      flake = false;
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mochou_nur = {
      url = "github:mochouaaaaa/nur-packages";
    };

    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    nixos-anywhere = {
      url = "github:nix-community/nixos-anywhere";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
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
        inputs.flake-parts.flakeModules.partitions
        inputs.flake-parts.flakeModules.modules

        (inputs.import-tree ./modules)
      ];

      systems = [ ];

      flake =
        let
          nixos = config.partitions.nixos.module.flake;
          darwin = config.partitions.darwin.module.flake;
          merge = attr: lib.recursiveUpdate (nixos.${attr} or { }) (darwin.${attr} or { });
        in
        {
          packages = merge "packages";
          apps = merge "apps";
          checks = merge "checks";
          devShells = merge "devShells";
          formatter = merge "formatter";
        };

      partitionedAttrs = {
        nixosConfigurations = "nixos";
        darwinConfigurations = "darwin";
      };

      partitions.nixos = {
        extraInputsFlake = ./partitions/nixos;
        module.imports = [ ./partitions/nixos/flake-module.nix ];
      };

      partitions.darwin = {
        extraInputsFlake = ./partitions/darwin;
        module.imports = [ ./partitions/darwin/flake-module.nix ];
      };

    });

}
