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

    modules'.packages.terminal.kitty = {
      extraConfig = lib.mkAfter [
        "mouse_map        cmd+left click ungrabbed mouse_handle_click link"
      ];
    };

    xdg.configFile = {
      "kitty/kitty.app.icns".source = "${cfg.icon}/kitty-dark.icns";
    };
  };
}
