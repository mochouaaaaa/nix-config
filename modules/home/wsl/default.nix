{ lib, self, ... }:
{
  imports = lib.importModule' ./. ++ [
    self.homeModules.base
    self.homeModules.linux.modules
  ];

  config = {

    dconf.enable = lib.mkForce false;

  };

}
