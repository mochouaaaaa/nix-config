{ lib, ... }:
{

  config = {
    dconf.enable = lib.mkForce false;
  };

}
