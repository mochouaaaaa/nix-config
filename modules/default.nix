{ inputs, self, ... }:
let
  inherit (inputs) import-tree;
  homeShared = import-tree ./sharedModules/home-manager;
  osShared = import-tree ./sharedModules/os;
in
{
  flake = {
    nixosModules = {
      base = import-tree ./nixos/base;
      services = import-tree ./nixos/services;
      virtual = import-tree ./nixos/virtual;
      desktop = import-tree ./nixos/desktop;

      shared = osShared;
      secrets = "${self}/secrets/nixos.nix";
    };

    darwinModules = {
      base = import-tree ./darwin; # darwin modules
      shared = osShared;
      secrets = "${self}/secrets/darwin.nix";
    };

    homeModules = {
      base = import-tree ./home/base;
      home = import-tree ./home; # home-manager modules
      linux = import-tree ./home/linux;
      darwin = import-tree ./home/darwin;
      wsl = import-tree ./home/wsl;

      shared = homeShared;
      secrets = "${self}/secrets/home.nix";
    };
  };
}
