{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.packages.kitty;
in
{
  config = lib.mkIf cfg.enable {

    programs.kitty.settings = {
      background_opacity = 0.75;
    };

    xdg.configFile = {
      "kitty/kitty.app.icns".source = "${cfg.icon}/kitty-dark.icns";
    };
  };
}
