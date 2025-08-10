{
  config,
  lib,
  pkgs,
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
          "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent"

          "hyprctl setcursor ${config.home.pointerCursor.name} ${builtins.toString config.home.pointerCursor.size}"

          "wl-paste --type text --watch cliphist store"
          "wl-paste --type image --watch cliphist store"

          "nm-applet --indicator &"

          "swww-daemon --format xrgb"
          "${lib.getExe pkgs.pywal16} -i $HOME/.current_wallpaper"
        ];
      };
    };
  };
}
