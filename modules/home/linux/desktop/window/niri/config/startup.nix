{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let

  cfg = config.modules'.desktop.niri;
  # swww = inputs.swww.packages.${pkgs.system}.swww;
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

            "nm-applet --indicator &"

            "wl-paste --type text --watch cliphist store"
            "wl-paste --type image --watch cliphist store"
            # "${swww}/bin/swww-daemon --format xrgb"
            # "${swww}/bin/swww img $HOME/.current_wallpaper"
            # "${lib.getExe pkgs.pywal16} -i $HOME/.current_wallpaper"
          ];
    };
  };
}
