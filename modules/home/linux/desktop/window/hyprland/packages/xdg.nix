{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {

    xdg = {
      portal = {
        config = {
          hyprland = {
            default = [ "hyprland" ] ++ [ config.xdg.portal.config.common.default ];
            "org.freedesktop.impl.portal.RemoteDesktop" = "hyprland";
            "org.freedesktop.impl.portal.Screenshot" = "hyprland";
            "org.freedesktop.impl.portal.ScreenCast" = "hyprland";
            "org.freedesktop.impl.portal.Settings" = "gtk";
          };
        };
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-gnome
          inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
        ];
      };
    };

  };
}
