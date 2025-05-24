{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    xdg = {
      portal = {
        config = {
          hyprland = {
            default = [ "hyprland" ] ++ [ config.xdg.portal.config.common.default ];
          };
        };
      };
    };

    home.pointerCursor = {
      hyprcursor = {
        enable = true;
      };
    };
  };
}
