{
  pkgs,
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
        waybar.enable = true;
        rofi.enable = true;
        wlogout.enable = true;
        swaync.enable = true;
        swaylock.enable = true;
      };
    };

  };
}
