{
  lib,
  inputs,
  config,
  ...
}:
let
  _imports = import ./imports.nix { inherit lib; };
in
{

  imports = [
    ./pkgs.nix
    ./dev-shells
  ];

  flake = {
    importModule' = _imports.importModule';
  };

  _module.args = {
    getSystems = {
      nixosSystem = import ./nixosSystem.nix;
      macosSystem = import ./macosSystem.nix;
      otherSystem = import ./otherSystem.nix;
    };
  };
}
