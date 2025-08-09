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
    xdg.portal = {
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
}
