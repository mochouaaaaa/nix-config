{ config, lib, ... }:
let
  cfg = config.profiles.desktop;
in
{
  config = lib.mkIf (cfg.hyprland.enable || cfg.niri.enable || cfg.gnome.enable) {

    qt = {
      enable = true;
      platformTheme.name = "gtk3";
    };

  };

}
