{
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.niri;
in
{
  config = lib.mkIf cfg.enable {

    modules'.desktop.shell.dankMaterialShell.enable = false;
    modules'.desktop.shell.noctalia.enable = true;
    modules'.desktop.services.vicinae.enable = true;

  };
}
