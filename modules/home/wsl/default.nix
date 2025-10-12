{ lib, self, ... }:
{
  imports = lib.importModule' ./. ++ [
    self.homeModules.linux.modules
  ];

  config = {

    dconf.enable = lib.mkForce false;

    services.xremap = {
      enable = false;
    };

  };

}
