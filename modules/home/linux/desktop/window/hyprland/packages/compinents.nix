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
      ashell.enable = true;
      waybar.enable = false;
      rofi.enable = true;
      wlogout.enable = true;
      swaync.enable = true;
      swaylock.enable = false;
    };

  };
}
