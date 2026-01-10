{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.packages.terminal.kitty;
in
{
  config = lib.mkIf cfg.enable {
    programs.kitty = {
      darwinLaunchOptions = [
        "--single-instance"
        "--listen-on=unix:/tmp/mykitty.sock"
      ];
    };

    profiles.packages.terminal.kitty = {
      extraConfig = [
        "mouse_map        cmd+left click ungrabbed mouse_handle_click link"
      ];
    };

    xdg.configFile = {
      "kitty/kitty.app.icns".source = "${cfg.icon}/kitty-dark.icns";
    };
  };
}
