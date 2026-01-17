{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.profiles.desktop;
  cfgHyprland = config.wayland.windowManager.hyprland;
in
{
  # This module centralizes the configuration of xdg-desktop-portal backends
  # for various desktop environments to avoid duplication.
  config = {
    xdg.portal = {
      # Add DE-specific portal packages to the system.
      # GTK is included as a general fallback.
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ]
      ++ lib.optionals cfg.gnome.enable [ pkgs.xdg-desktop-portal-gnome ]
      ++ lib.optionals cfg.kde.enable [ pkgs.kdePackages.xdg-desktop-portal-kde ]
      ++ lib.optionals (cfgHyprland.portalPackage != null) [
        cfgHyprland.portalPackage
      ];

      # Niri acts as its own portal backend, so its package is needed here.
      configPackages = lib.optionals cfg.niri.enable [ config.programs.niri.package ];

      # Recursively merge portal configurations from different DEs.
      # This sets the preferred `default` portal implementation and other
      # DE-specific settings for interfaces like screencasting or settings.
      config = lib.mkMerge [
        (lib.mkIf (cfgHyprland.enable) {
          hyprland = {
            default = [ "hyprland" ] ++ [ config.xdg.portal.config.common.default ];
            "org.freedesktop.impl.portal.RemoteDesktop" = "hyprland";
            "org.freedesktop.impl.portal.Screenshot" = "hyprland";
            "org.freedesktop.impl.portal.ScreenCast" = "hyprland";
            "org.freedesktop.impl.portal.Settings" = "gnome";
          };
        })

        (lib.mkIf cfg.kde.enable {
          kde = {
            default = [ "kde" ] ++ [ config.xdg.portal.config.common.default ];
          };
        })

        (lib.mkIf cfg.gnome.enable {
          gnome = {
            default = [ "gnome" ] ++ [ config.xdg.portal.config.common.default ];
          };
        })

        (lib.mkIf cfg.niri.enable {
          niri = {
            default = [ "niri" ] ++ [ config.xdg.portal.config.common.default ];
            "org.freedesktop.impl.portal.Settings" = "gnome";
          };
        })

      ];

    };
  };
}
