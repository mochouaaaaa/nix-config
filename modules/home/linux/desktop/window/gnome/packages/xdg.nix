{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.gnome;
in
{
  config = lib.mkIf cfg.enable {
    xdg.portal = {
      config = {
        gnome = {
          default = [ "gnome" ] ++ [ config.xdg.portal.config.common.default ];
        };
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
    };
  };
}
