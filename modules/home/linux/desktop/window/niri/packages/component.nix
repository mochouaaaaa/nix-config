{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.niri;
in
{
  config = lib.mkIf cfg.enable {

    modules.desktop = {
      component = {
        launcher = {
          rofi.enable = false;
          fuzzel.enable = true;
        };
        status-bar = {
          waybar.enable = true;
        };
        wlogout.enable = true;
        swaync.enable = true;
        swaylock.enable = true;
      };
    };

  };
}
