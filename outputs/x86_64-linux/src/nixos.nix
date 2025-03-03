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
  name = "nixos";
  modules = {
    nixos-modules =
      map mylib.relativeToRoot ["hosts/nixos" "modules/nixos/desktop.nix"]
      ++ [
        inputs.honkai-railway-grub-theme.nixosModules.${system}.default
        # inputs.stylix.nixosModules.stylix
      ];

    home-modules =
      map mylib.relativeToRoot ["home/linux/gui.nix"]
      ++ [
        inputs.nix-flatpak.homeManagerModules.nix-flatpak
        inputs.xremap-flake.homeManagerModules.default
        inputs.stylix.homeManagerModules.stylix
      ]
      ++ lib.optionals (myvars.desktop.kde) [inputs.plasma-manager.homeManagerModules.plasma-manager];
  };
in {
  nixosConfigurations = {
    "${name}" = mylib.nixosSystem (modules // args);
  };

  # generate iso image for hosts with desktop environment
  packages = {
    "${name}" = inputs.self.nixosConfigurations."${name}".config.formats.iso;
  };
}
