{
  # NOTE: the args not used in this file CAN NOT be removed!
  # because haumea pass argument lazily,
  # and these arguments are used in the functions like `mylib.nixosSystem`, `mylib.colmenaSystem`, etc.
  inputs,
  lib,
  myvars,
  mylib,
  system,
  genSpecialArgs,
  ...
} @ args: let
  name = "ubuntu";
  base-modules = {
    home-modules =
      map mylib.relativeToRoot ["home/linux/gui.nix"]
      ++ [
        inputs.xremap-flake.homeManagerModules.default
        inputs.nix-flatpak.homeManagerModules.nix-flatpak
        inputs.stylix.homeManagerModules.stylix
      ];
  };

  modules-hyprland = {home-modules = [] ++ base-modules.home-modules;};
  modules = modules-hyprland // args;
in {homeConfigurations."${name}" = mylib.otherSystem modules;}
