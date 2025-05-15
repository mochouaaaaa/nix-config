{ config, lib, ... }:
let
  cfg = config.modules.desktop.kde;
  fontConfig = {
    family = "Monaco Nerd Font Mono";
    pointSize = 12;
  };
in
{
  config = lib.mkIf cfg.enable {
    programs.plasma = {
      fonts = {
        general = fontConfig;
        fixedWidth = fontConfig // {
          family = "Maple Mono NF";
          pointSize = 10;
        };
        small = fontConfig // {
          family = "inter";
          pointSize = 8;
        };
        toolbar = fontConfig // {
          family = "inter";
          pointSize = 10;
        };
        menu = fontConfig // {
          family = "inter";
          pointSize = 10;
        };
        windowTitle = fontConfig // {
          pointSize = 10;
        };
      };
    };
  };
}
