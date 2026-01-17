{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.desktop;
in
{

  config = lib.mkIf (cfg.hyprland.enable || cfg.niri.enable) {

    services.blueman-applet.enable = true;
    services.network-manager-applet.enable = true;
    services.cliphist.enable = true;

  };

}
