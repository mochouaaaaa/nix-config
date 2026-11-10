{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.profiles.desktop.niri;
in
{
  config = lib.mkIf cfg.enable {

    # wayland.windowManager.niri.settings = {
    #   spawn-at-startup._children =
    #     map
    #       (s: {
    #         spawn-at-startup._args = [
    #           (pkgs.lib.strings.splitString " " s)
    #         ];
    #       })
    #       [
    #         "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    #         "dbus-update-activation-environment --systemd --all"
    #       ];
    # };

  };
}
