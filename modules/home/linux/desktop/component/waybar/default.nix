{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.modules.desktop.component.waybar;
in
{
  options.modules.desktop.component.waybar = {
    enable = lib.mkEnableOption "Waybar status bar" // {
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      font-awesome
    ];

    programs.waybar = {
      enable = true;
      package = inputs.waybar.packages.${pkgs.system}.waybar;
      systemd = {
        enable = true;
        target = "hyprland-session.target";
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
