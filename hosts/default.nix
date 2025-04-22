{
  inputs,
  lib,
  self,

  pkgs-unstable,
  pkgs-stable,

  ...
}:
let
  inherit (inputs) nixpkgs;

  genSpecialArgs =
    system:
    inputs
    // rec {
      inherit
        self
        inputs
        pkgs-stable
        pkgs-unstable
        ;
      isNixos = builtins.pathExists "/etc/nixos";
      isLinux = nixpkgs.legacyPackages.${system}.stdenv.isLinux && !isNixos;
    };
  args = {
    inherit
      self
      inputs
      lib
      genSpecialArgs
      ;
  };
  nixosSystems = {
    x86_64-linux = import ./x86_64-linux (args // { system = "x86_64-linux"; });
  };
  darwinSystems = {
    x86_64-darwin = import ./x86_64-darwin (args // { system = "x86_64-darwin"; });
  };

  otherSystems = {
    x86_64-linux = import ./x86_64-linux (args // { system = "x86_64-linux"; });
  };

  nixosSystemValues = builtins.attrValues nixosSystems;
  darwinSystemValues = builtins.attrValues darwinSystems;
  otherSystemValues = builtins.attrValues otherSystems;
in
{
  flake = {
    nixosConfigurations = lib.attrsets.mergeAttrsList (
      map (it: it.nixosConfigurations or { }) nixosSystemValues
    );
    darwinConfigurations = lib.attrsets.mergeAttrsList (
      map (it: it.darwinConfigurations or { }) darwinSystemValues
    );
    homeConfigurations = lib.attrsets.mergeAttrsList (
      map (it: it.homeConfigurations or { }) otherSystemValues
    );
  };
}
