{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {

    services.xremap.withWlroots = lib.mkForce true;

  };
}
