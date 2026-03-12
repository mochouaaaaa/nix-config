{ config, lib, ... }:
let
  cfg = config.profiles.desktop;
in
{
  config = lib.mkIf (cfg.hyprland.enable || cfg.niri.enable || cfg.gnome.enable) {

    programs.quickshell = {
      enable = true;
      systemd.enable = false;
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk3";
    };

  };

}
