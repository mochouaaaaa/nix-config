{
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.packages.terminal.kitty;
in
{
  config = lib.mkIf cfg.enable {

    xdg.configFile = {
      "kitty/kitty.app.icns".source = "${cfg.icon}/kitty-dark.icns";
    };
  };
}
