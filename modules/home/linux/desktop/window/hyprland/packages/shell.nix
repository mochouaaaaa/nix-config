{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {

    profiles.desktop.shell.caelestia.enable = false;
    profiles.desktop.shell.noctalia.enable = true;
    profiles.desktop.shell.dank-material-shell.enable = false;

  };
}
