{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
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
          hyprland = {
            default = [ "hyprland" ] ++ [ config.xdg.portal.config.common.default ];
            "org.freedesktop.impl.portal.Screenshot" = "hyprland";
            "org.freedesktop.impl.portal.ScreenCast" = "hyprland";
            "org.freedesktop.impl.portal.GlobalShortcuts" = "hyprland";
            "org.freedesktop.impl.portal.Settings" = "gtk";
          };
        };
        extraPortals = lib.mkAfter [
          pkgs.xdg-desktop-portal-gtk
          pkgs.xdg-desktop-portal-gnome
        ];
      };
    };

  };
}
