{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.modules.desktop.niri;
in
{
  config = lib.mkIf cfg.enable {

    programs.niri.settings = {
      spawn-at-startup =
        map
          (s: {
            command = pkgs.lib.strings.splitString " " s;
          })
          [
            "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
            "dbus-update-activation-environment --systemd --all"

            "swww-daemon --format xrgb"
            "nm-applet --indicator &"

            "wl-paste --type text --watch cliphist store"
            "wl-paste --type image --watch cliphist store"
          ];
    };
  };
}
