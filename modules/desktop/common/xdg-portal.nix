_:
let
  gnomePortalConfig = {
    "org.freedesktop.impl.portal.Settings" = "gnome";
    "org.freedesktop.impl.portal.ScreenCast" = "gnome";
    "org.freedesktop.impl.portal.Screenshot" = "gnome";
  };
in
{

  flake.modules.homeManager."desktop.hyprland" = { pkgs, config, ... }: {
    xdg.portal = {
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
      config = {
        hyprland = {
          default = [ "hyprland" ] ++ config.xdg.portal.config.common.default;
          "org.freedesktop.impl.portal.RemoteDesktop" = "hyprland";
          "org.freedesktop.impl.portal.Screenshot" = "hyprland";
          "org.freedesktop.impl.portal.ScreenCast" = "hyprland";
        };
      };
    };
  };

  flake.modules.homeManager."desktop.niri" = { pkgs, config, ... }: {
    xdg.portal = {
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
      configPackages = [ config.wayland.windowManager.niri.portalPackage ];
      config = {
        default = [ "niri" ] ++ config.xdg.portal.config.common.default;
      }
      // gnomePortalConfig;
    };
  };

  flake.modules.homeManager."desktop.gnome" = { pkgs, config, ... }: {
    xdg.portal = {
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
      config = {
        default = [ "gnome" ] ++ config.xdg.portal.config.common.default;
      }
      // gnomePortalConfig;
    };
  };

  flake.modules.homeManager."desktop.kde" = { pkgs, config, ... }: {
    xdg.portal = {
      extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
      config = {
        default = [ "kde" ] ++ config.xdg.portal.config.common.default;
      };
    };
  };

  flake.modules.homeManager."desktop.common" =
    {
      pkgs,
      ...
    }:
    {
      config = {
        xdg.portal = {
          extraPortals = [
            pkgs.xdg-desktop-portal-gtk
          ];
        };
      };
    };
}
