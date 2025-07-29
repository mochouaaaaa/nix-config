{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        exec-once = [
          "hyprctl setcursor WhiteSur-cursors 36"

          "wl-paste --type text --watch cliphist store"
          "wl-paste --type image --watch cliphist store"

          "nm-applet --indicator &"

          "swww-daemon --format xrgb"

          "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "dbus-update-activation-environment --systemd --all"
        ];
      };
    };
  };
}
