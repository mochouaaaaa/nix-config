{
  lib,
  config,
  mylib,
  ...
}: let
  cfg = config.modules.desktop.niri;
in {
  imports = mylib.scanPaths ./.;

  options.modules.desktop.niri = {
    enable = lib.mkEnableOption "Niri - A Linux desktop environment" // {default = false;};
  };

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
