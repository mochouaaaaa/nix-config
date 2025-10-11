{ config, lib, ... }:
let

  cfg = config.modules'.desktop.niri;
in
{
  config = lib.mkIf cfg.enable {

    programs.niri.settings = {
      input = {
        keyboard = {

          xkb = {
            layout = "us";
          };

          repeat-delay = 200;
          repeat-rate = 40;

        };

        touchpad = {
          tap = true;
          accel-speed = 0.2;
        };

        mod-key = "Super";

        workspace-auto-back-and-forth = true;
      };
      layout = {
        gaps = 6;
        struts = {
          left = 5;
          right = 5;
          top = 2;
          bottom = 2;
        };
        focus-ring = {
          width = 2;
        };
        always-center-single-column = true;
      };
      cursor = {
        theme = config.home.pointerCursor.name;
        size = config.home.pointerCursor.size;
      };

      prefer-no-csd = true;
      hotkey-overlay.skip-at-startup = true;
      clipboard = {
        disable-primary = true;
      };
    };

  };
}
