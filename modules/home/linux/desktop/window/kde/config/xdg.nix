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
      extraPortals = lib.mkAfter [ pkgs.kdePackages.xdg-desktop-portal-kde ];
    };
  };
}
