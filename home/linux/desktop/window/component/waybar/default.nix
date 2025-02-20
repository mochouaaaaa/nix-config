{
  lib,
  myvars,
  ...
}: let
  enable = myvars.desktop.component.waybar;
in {
  programs.waybar = {
    enable = enable;
    systemd = {
      enable = enable;
      target = "hyprland-session.target";
    };
    style = lib.mkForce ./style.css;
  };

  xdg.configFile = {
    "waybar/config" = {
      source = ./config;
      force = true;
    };
    "waybar/modules" = {
      source = ./modules;
      force = true;
    };
  };
}
