{
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {

    modules'.desktop.shell.caelestia.enable = false;
    modules'.desktop.shell.noctalia.enable = false;
    modules'.desktop.shell.dankMaterialShell.enable = true;

    modules'.desktop.services.vicinae.enable = false;

  };
}
