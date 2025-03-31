{
  inputs,
  self,
  lib,
  myvars,
  mylib,
  system,
  genSpecialArgs,
  ...
} @ args: let
  home-modules = [
    self.homeModules.base.home
    self.homeModules.base.core
    self.homeModules.base.tools

    self.homeModules.linux.base
    self.homeModules.linux.gui
  ];

  modules = {home-modules = home-modules;} // args;
in {
  homeConfigurations = {
    ubuntu = mylib.otherSystem modules;
  };
}
