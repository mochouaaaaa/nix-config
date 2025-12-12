{
  lib,
  config,
  ...
}:
let
  cfg = config.programs.dankMaterialShell;
  cfgHyprland = config.modules'.desktop.hyprland;
in
{
  config = lib.mkIf (cfgHyprland.enable && cfg.enable) {

    modules'.desktop.services.vicinae.enable = lib.mkForce false;

  };
}
