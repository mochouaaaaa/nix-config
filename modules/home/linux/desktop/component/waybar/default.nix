{
  lib,
  config,
  ...
}: let
  cfg = config.modules.desktop.component.waybar;
in {
  options.modules.desktop.component.waybar = {
    enable = lib.mkEnableOption "Waybar status bar" // {default = false;};
  };

  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd = {
        enable = true;
        target = "wayland-session@Hyprland.target";
      };
      style = ./config/style.css;
    };

    xdg.configFile = {
      "waybar/config" = {
        source = ./config/config;
      };
      "waybar/modules" = {
        source = ./config/modules;
      };
      "waybar/colors" = {
        source = ./config/colors;
        recursive = true;
      };
      "waybar/themes" = {
        source = ./config/themes;
        recursive = true;
      };
    };
  };
}
