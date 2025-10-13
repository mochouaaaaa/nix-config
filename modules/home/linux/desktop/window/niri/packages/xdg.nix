{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.niri;
in
{
  config = lib.mkIf cfg.enable {

    home.packages = [ pkgs.loupe ];

    xdg = {
      mimeApps = {
        defaultApplications = {
          "image/png" = [ "org.gnome.Loupe.desktop" ];
          "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
          "image/webp" = [ "org.gnome.Loupe.desktop" ];
          "image/gif" = [ "org.gnome.Loupe.desktop" ];
        };
      };
      portal = {
        config = {
          niri = {
            default = [ "niri" ] ++ [ config.xdg.portal.config.common.default ];
          };
        };
        extraPortals = lib.mkAfter (
          with pkgs;
          [
            xdg-desktop-portal-gtk
            xdg-desktop-portal-gnome
          ]
        );
        configPackages = [ pkgs.niri ];
      };
    };

  };
}
