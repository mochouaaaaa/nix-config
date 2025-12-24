{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules'.desktop;
in
{

  config = lib.mkIf (cfg.hyprland.enable || cfg.niri.enable || cfg.gnome.enable) {

    home.packages = with pkgs; [
      libadwaita
    ];

    services.darkman = {
      enable = true;
      settings = {
        lat = 39.9042;
        lng = 116.4074;
        portal = true;
      };
    };
  };

}
