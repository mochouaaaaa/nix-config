{
  lib,
  self,
  inputs,
  system,
  mylib,
  myvars,
  genSpecialArgs,
  ...
}@args:
let
  modules = {
    nixos-modules = [
      ../nixos

      self.nixosModules.base
      self.nixosModules.services
      self.nixosModules.virtual
      self.nixosModules.desktop
      {
        # modules.desktop.kde.enable = true;
        modules.desktop.hyprland.enable = true;
        # modules.desktop.niri.enable = false;
        # modules.desktop.gnome.enable = true;

        modules.virtual = {
          docker.enable = true;
        };
      }
    ];

    home-modules = [
      self.homeModules.base.home
      self.homeModules.base.core
      self.homeModules.base.tools

      self.homeModules.linux.base
      self.homeModules.linux.gui

      {
        # modules.desktop.kde.enable = true;
        modules.desktop.hyprland.enable = true;
        #  modules.desktop.niri.enable = false;
        # modules.desktop.gnome.enable = true;

        modules.packages.jetbrains = {
          enable = true;
          pycharm.enable = true;
          goland.enable = true;
          datagrip.enable = true;
        };

        modules.packages.envs = {
          pyenv.enable = false;
          goenv.enable = false;
          nodenv.enable = false;
          luaenv.enable = false;
        };
      }
    ];
  };
in
{
  nixosConfigurations = {
    nixos = mylib.nixosSystem (modules // args);
  };
}
