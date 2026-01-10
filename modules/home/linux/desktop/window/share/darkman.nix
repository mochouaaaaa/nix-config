{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.desktop;
in
{

  config = lib.mkIf (cfg.hyprland.enable || cfg.niri.enable || cfg.gnome.enable) {

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
