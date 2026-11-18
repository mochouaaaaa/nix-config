{
  lib,
  self,
  config,
  ...
}:

let
  registry = import ../lib/host-registry.nix {
    inherit lib;
    inherit (config) hosts;
    hostsDir = ../hosts;
  };
in
{
  flake.lib.hostMetadata = registry.hostMetadata;
}
