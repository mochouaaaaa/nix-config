{
  lib,
  config,
  ...
}:
let
  cfgHyprland = config.modules'.desktop.hyprland;
  cfg = config.modules'.desktop.shell.caelestia;
in
{
  config = lib.mkIf (cfg.enable && cfgHyprland.enable) {

    modules'.desktop.hypridle.lock_cmd = "caelestia shell lock lock";

  };

}
