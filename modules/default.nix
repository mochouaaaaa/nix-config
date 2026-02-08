{ inputs, self, ... }:
let
  inherit (inputs) import-tree;
  homeShared = import-tree ./sharedModules/home-manager;
  osShared = import-tree ./sharedModules/os;
in
{
  flake = {
    nixosModules = {
      default = import-tree [
        ./nixos
        osShared
        "${self}/secrets/nixos.nix"
      ];
      # base = import-tree ./nixos/base;
      # services = import-tree ./nixos/services;
      # virtual = import-tree ./nixos/virtual;
      # desktop = import-tree ./nixos/desktop;
    };

    darwinModules = {
      default = import-tree [
        ./darwin
        osShared
        "${self}/secrets/darwin.nix"
      ];
    };

    homeModules = rec {
      default = import-tree [
        ./home/base
        homeShared
        "${self}/secrets/home.nix"
      ];
      # base = import-tree ./home/base;
      linux = import-tree [
        default
        ./home/linux
      ];
      darwin = import-tree [
        default
        ./home/darwin
      ];
      wsl = import-tree [
        linux
        ./home/wsl
      ];

      # shared = homeShared;
      # secrets = "${self}/secrets/home.nix";
    };
  };
}
