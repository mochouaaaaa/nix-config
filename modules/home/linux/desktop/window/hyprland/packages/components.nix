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

    #  modules'.desktop.component = {
    #    launcher = {
    #      rofi.enable = false;
    #      fuzzel.enable = true;
    #      walker.enable = false;
    #    };
    #    status-bar = {
    #      ashell.enable = false;
    #      waybar.enable = true;
    #    };
    #    wlogout.enable = true;
    #    swaync.enable = true;
    #    swaylock.enable = false;
    #  };

  };
}
