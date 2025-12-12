{
  lib,
  config,
  ...
}:
let
  cfg = config.modules'.desktop.shell.noctalia;
  cfgNiri = config.modules'.desktop.niri;
in
{

  config = lib.mkIf (cfg.enable && cfgNiri.enable) {

    modules'.desktop.shell.noctalia.settings = {
      general = {
        showScreenCorners = false;
      };
    };

  };
}
