{
  self,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.desktop.component.waybar;
in
{

  imports = [
    ./settings.nix
    ./style-css.nix
  ];

  config = lib.mkIf cfg.enable {

    xdg.configFile = {
      "waybar/modules" = {
        source = ./modules;
      };
      "waybar/colors" = {
        source = ./colors;
        recursive = true;
      };
      "waybar/themes" = {
        source = ./themes;
        recursive = true;
      };
    };

  };
}
