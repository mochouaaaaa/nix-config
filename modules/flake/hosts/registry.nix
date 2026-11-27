{
  inputs,
  lib,
  self,
  config,
  ...
}:

let
  registry = import ../../../lib/host-registry.nix {
    inherit inputs lib;
    inherit (config) hosts;
    hostsDir = ../../../hosts;
  };

  configurations = import ../../../lib/host-configurations.nix {
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
  flake = {
    lib.hostMetadata = registry.hostMetadata;
    inherit (configurations)
      nixosConfigurations
      darwinConfigurations
      homeConfigurations
      ;
  };
}
