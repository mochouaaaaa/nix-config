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
            default = [ "hyprland" ] ++ (config.xdg.config.common.default or [ ]);
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
