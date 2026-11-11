{
  lib,
  inputs,
  ...
}:

lib.recursiveUpdate (import ./recursive.nix { inherit lib; }) {
  hm = inputs.home-manager.lib.hm;
}
