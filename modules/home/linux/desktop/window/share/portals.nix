{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.modules'.desktop;
in
{
  # This module centralizes the configuration of xdg-desktop-portal backends
  # for various desktop environments to avoid duplication.
  config = {
    xdg.portal = {
      # The main `enable` flag is set in a base module.

      # Add DE-specific portal packages to the system.
      # GTK is included as a general fallback.
      extraPortals =
        with pkgs;
        [
          xdg-desktop-portal-gtk
        ]
        ++ lib.optionals cfg.gnome.enable [ xdg-desktop-portal-gnome ]
        ++ lib.optionals cfg.kde.enable [ kdePackages.xdg-desktop-portal-kde ]
        ++ lib.optionals cfg.hyprland.enable [
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
        ];

      # Niri acts as its own portal backend, so its package is needed here.
      configPackages = lib.optionals cfg.niri.enable [ pkgs.niri ];

      # Recursively merge portal configurations from different DEs.
      # This sets the preferred `default` portal implementation and other
      # DE-specific settings for interfaces like screencasting or settings.
      config = {
        hyprland = lib.mkIf cfg.hyprland.enable {
          default = [ "hyprland" ] ++ [ config.xdg.portal.config.common.default ];
          "org.freedesktop.impl.portal.RemoteDesktop" = "hyprland";
          "org.freedesktop.impl.portal.Screenshot" = "hyprland";
          "org.freedesktop.impl.portal.ScreenCast" = "hyprland";
          "org.freedesktop.impl.portal.Settings" = "gnome";
        };

        kde = lib.mkIf cfg.kde.enable {
          default = [ "kde" ] ++ [ config.xdg.portal.config.common.default ];
        };

        gnome = lib.mkIf cfg.gnome.enable {
          default = [ "gnome" ] ++ [ config.xdg.portal.config.common.default ];
        };

        niri = lib.mkIf cfg.niri.enable {
          default = [ "niri" ] ++ [ config.xdg.portal.config.common.default ];
          "org.freedesktop.impl.portal.Settings" = "gnome";
        };
      };
    };
  };
}
