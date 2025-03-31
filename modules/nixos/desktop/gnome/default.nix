{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.gnome;
in {
  options.modules.desktop.gnome = {
    enable = lib.mkEnableOption "Gnome desktop environment";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      xorg.xev
      wev
    ];

    modules.dm.gdm.enable = true;

    services = {
      udisks2.enable = true;
      xserver = {
        enable = true;
        desktopManager = {
          gnome.enable = true;
        };
        xkb.layout = "us";
      };
      gnome = {
        gnome-keyring.enable = true;
        gnome-browser-connector.enable = true;
      };
      fwupd = {enable = true;};
    };

    environment.gnome.excludePackages = [
      pkgs.gnome-software
    ];

    qt = {
      enable = true;
      platformTheme = "gnome";
      style = lib.mkForce "adwaita";
    };
  };
}
