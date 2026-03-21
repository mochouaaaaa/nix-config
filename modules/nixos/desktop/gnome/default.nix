{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.profiles.desktop.gnome;
in
{

  config = lib.mkIf cfg.enable {

    profiles.display-manager.gdm.enable = true;

    services = {
      xserver = {
        xkb.layout = "us";
      };
      desktopManager = {
        gnome.enable = true;
      };
      gnome = {
        gnome-browser-connector.enable = true;
      };
      udev.packages = [ pkgs.gnome-settings-daemon ];
    };

  };
}
