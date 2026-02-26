{
  inputs,
  self,
  ...
}:
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
        "${self}/secrets/nixos"
      ];
    };

    darwinModules = {
      default = import-tree [
        ./darwin
        osShared
        "${self}/secrets/darwin"
      ];
    };

    homeModules = rec {
      default = import-tree [
        ./home/base
        homeShared
        "${self}/secrets/home"
      ];
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
    };
  };
}
