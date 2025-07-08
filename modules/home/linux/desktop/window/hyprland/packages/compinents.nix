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

    modules.desktop.component = {
      ashell.enable = false;
      waybar.enable = true;
      rofi.enable = true;
      wlogout.enable = true;
      swaync.enable = true;
      swaylock.enable = false;
    };

  };
}
