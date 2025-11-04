{
  lib,
  config,
  ...
}:
let
  cfgHyprland = config.modules'.desktop.hyprland;
  cfgCaelestia = config.modules'.desktop.shell.caelestia;
in
{
  imports = lib.importModule' ./.;

  config = lib.mkIf (cfgHyprland.enable && cfgCaelestia.enable) {

  };
}
