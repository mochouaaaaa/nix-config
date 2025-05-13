{
  lib,
  inputs,
  config,
  ...
}:
let
  _pkgs = import ./pkgs.nix { inherit inputs config; };
  _imports = import ./imports.nix { inherit lib; };
in
{

  flake = {
    importModule' = _imports.importModule';
  };

  _module.args = {
    inherit (_pkgs)
      pkgs
      pkgs-unstable
      pkgs-stable
      nvfetcherSources
      ;
    getSystems = {
      nixosSystem = import ./nixosSystem.nix;
      macosSystem = import ./macosSystem.nix;
      otherSystem = import ./otherSystem.nix;
    };
  };
}
