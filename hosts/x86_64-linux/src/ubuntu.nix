{
  inputs,
  self,
  lib,
  system,
  genSpecialArgs,
  ...
}@args:
let
  home-modules = [
    self.homeModules.base.home
    self.homeModules.base.core
    self.homeModules.base.tools

    self.homeModules.linux.base
    self.homeModules.linux.gui

    {
      modules.desktop.gnome.enable = true;
    }
  ];

  modules = {
    home-modules = home-modules;
  } // args;
in
{
  homeConfigurations = {
    ubuntu = self.mylib.otherSystem modules;
  };
}
