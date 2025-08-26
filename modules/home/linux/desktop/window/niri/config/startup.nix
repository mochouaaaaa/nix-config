{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.modules'.desktop.niri;
in
{
  config = lib.mkIf cfg.enable {

    services.network-manager-applet.enable = true;
    modules'.desktop.services.cliphist.enable = true;

    programs.niri.settings = {
      spawn-at-startup =
        map
          (s: {
            command = pkgs.lib.strings.splitString " " s;
          })
          [
            "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
            "dbus-update-activation-environment --systemd --all"

            # "${swww}/bin/swww-daemon --format xrgb"
            # "${swww}/bin/swww img $HOME/.current_wallpaper"
            # "${lib.getExe pkgs.pywal16} -i $HOME/.current_wallpaper"
          ];
    };
  };
}
