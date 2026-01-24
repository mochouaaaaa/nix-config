{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.desktop;
  gnomeSeries = cfg.hyprland.enable || cfg.niri.enable || cfg.gnome.enable;
in
{

  config = lib.mkIf gnomeSeries {

    programs = {
      evolution = {
        enable = true;
        plugins = [ pkgs.evolution-ews ];
      };
    };

  };
}
