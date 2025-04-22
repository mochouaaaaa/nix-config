{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.kde;
in
{
  config = lib.mkIf cfg.enable {
    xdg.portal = {
      config = {
        kde = {
          default = [ "kde" ] ++ (config.xdg.config.common.default or [ ]);
        };
      };
      extraPortals =
        with pkgs;
        [ kdePackages.xdg-desktop-portal-kde ] ++ (config.xdg.portal.extraPortals or [ ]);
    };
  };
}
