{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.niri;
in
{
  config = lib.mkIf cfg.enable {
    xdg.portal = {
      config = {
        niri = {
          default = [ "niri" ] ++ (config.xdg.config.common.default or [ ]);
        };
      };
      extraPortals =
        with pkgs;
        [
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
          xdg-desktop-portal-gnome
        ]
        ++ (config.xdg.portal.extraPortals or [ ]);
    };
  };
}
