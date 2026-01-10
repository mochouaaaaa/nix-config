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

    modules.display-manager.gdm.enable = true;

    services = {
      udisks2.enable = true;
      xserver = {
        xkb.layout = "us";
      };
      xserver.desktopManager = {
        gnome.enable = true;
      };
      gnome = {
        gnome-browser-connector.enable = true;
      };
      udev.packages = [ pkgs.gnome-settings-daemon ];
    };

  };
}
