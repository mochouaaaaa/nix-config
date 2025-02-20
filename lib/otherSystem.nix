{
  lib,
  inputs,
  home-modules ? [],
  myvars,
  system,
  genSpecialArgs,
  specialArgs ? (genSpecialArgs system),
  ...
}: let
  inherit (inputs) nixpkgs home-manager;

  pkgs = import inputs.nixpkgs {
    inherit system myvars specialArgs;
    config = {
      allowUnfree = true;
      substituters = ["https://cache.nixos.org"];
    };
  };
in
  home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = home-modules ++ [./nix.nix];
    extraSpecialArgs = specialArgs;
  }
