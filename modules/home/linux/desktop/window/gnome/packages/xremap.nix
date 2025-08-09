{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.gnome;
in
{
  config = lib.mkIf cfg.enable {

    services.xremap.withGnome = lib.mkForce true;

  };
}
