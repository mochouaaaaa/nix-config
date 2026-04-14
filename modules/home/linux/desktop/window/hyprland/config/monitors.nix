{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        # monitor = ",2560x1440@60, auto, 1, bitdepth,10, cm,srgb";
        # monitor = "DP-1, 2560x1440@60, 0x0, 1, bitdepth, 10, cm, srgb";
        monitor = "DP-1, 3840x2160@60, 0x0, 1.5, bitdepth, 10, cm, srgb";
        #monitor = eDP-1, preferred, auto, 1
        #monitor = eDP-1, 2560x1440@165, 0x0, 1 #own screen
        #monitor = DP-3, 1920x1080@240, auto, 1
        #monitor = DP-1, preferred, auto, 1
        #monitor = HDMI-A-1, preferred,auto,1
      };
    };
  };
}
