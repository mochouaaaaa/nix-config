{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.desktop.niri;
in
{
  config = lib.mkIf cfg.enable {

    profiles.desktop.shell.dank-material-shell.enable = false;
    profiles.desktop.shell.noctalia.enable = true;

  };
}
