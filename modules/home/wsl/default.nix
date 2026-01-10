{ lib, self, ... }:
{
  imports = [ self.homeModules.linux ];

  config = {
    dconf.enable = lib.mkForce false;
  };

}
