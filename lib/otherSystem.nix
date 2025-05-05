{
  self,
  lib,
  inputs,
  home-modules ? [ ],
  system,
  genSpecialArgs,
  specialArgs ? (genSpecialArgs system),
  ...
}:
let
  inherit (inputs) nixpkgs home-manager;

  pkgs = import inputs.nixpkgs {
    inherit system self specialArgs;
    config = {
      allowUnfree = true;
      substituters = [ "https://cache.nixos.org" ];
    };
  };
in
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  modules = home-modules;
  extraSpecialArgs = specialArgs;
}
