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

    wayland.windowManager.hyprland = {
      settings = {
        exec-once = [
          "hyprctl setcursor ${config.home.pointerCursor.name} ${builtins.toString config.home.pointerCursor.size}"
        ];
      };
    };
  };
}
