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

    systemd.user.services.darkman = {
      Unit = {
        StartLimitIntervalSec = 30;
        StartLimitBurst = 5;
      };
      Service = {
        Restart = "on-failure";
        RestartSec = "3s";
      };
    };

  };

}
