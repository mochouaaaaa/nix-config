{
  inputs,
  lib,
  self,
  ...
}:
let
  inherit (inputs) nixpkgs;

  genSpecialArgs =
    system:
    inputs
    // rec {
      inherit self inputs;

      # use unstable branch for some packages to get the latest updates
      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit
          system
          ; # refer the `system` parameter form outer scope recursively
        # To use chrome, we need to allow the installation of non-free software
        config.allowUnfree = true;
      };
      pkgs-stable = import inputs.nixpkgs-stable {
        inherit system;
        # To use chrome, we need to allow the installation of non-free software
        config.allowUnfree = true;
      };
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
