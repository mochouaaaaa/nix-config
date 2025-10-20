{
  lib,
  config,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
  cfgCaelestia = config.modules'.desktop.shell.caelestia;
in
{
  imports = lib.importModule' ./.;

  config = lib.mkIf (cfg.enable && cfgCaelestia.enable) {

  };
}
