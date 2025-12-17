{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules'.desktop.gnome;
in
{
  imports = lib.importModule' ./.;

  config = lib.mkIf cfg.enable {

    programs = {
      ssh.startAgent = lib.mkForce false;
    };

    modules.dm.gdm.enable = true;

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
