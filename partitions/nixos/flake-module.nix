{
  config,
  inputs,
  lib,
  self,
  ...
}:

let
  registry = import ../../lib/host-registry.nix {
    inherit lib;
    inherit (config) hosts;
    hostsDir = ../../hosts;
  };

  configurations = import ../../lib/host-configurations.nix {
    inherit
      config
      inputs
      lib
      self
      registry
      ;
  };
in
{

  imports = [
    inputs.home-manager.flakeModules.home-manager
    ./per-system.nix
  ];

  flake.nixosConfigurations = configurations.nixosConfigurations;
}
