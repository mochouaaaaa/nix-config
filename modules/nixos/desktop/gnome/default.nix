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
      nautilus-open-any-terminal = {
        enable = true;
        terminal = "kitty";
      };
    };

    modules.dm.gdm.enable = true;

    services = {
      udisks2.enable = true;
      xserver = {
        enable = true;
        xkb.layout = "us";
      };
      xserver.desktopManager = {
        gnome.enable = true;
      };
      gnome = {
        sushi.enable = true;
        gnome-keyring.enable = true;
        gnome-browser-connector.enable = true;
      };
      udev.packages = lib.mkAfter [ pkgs.gnome-settings-daemon ];
    };

  };
}
