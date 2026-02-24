{
  config,
  lib,
  pkgs,
  # inputs,
  ...
}:
let
  cfg = config.profiles.desktop.niri;
in
{
  config = lib.mkIf cfg.enable {

    programs.niri = {
      settings = {
        xwayland-satellite = {
          enable = true;
          path = lib.getExe pkgs.xwayland-satellite;
        };
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
          background-color = "transparent";
        };
        cursor = {
          theme = config.home.pointerCursor.name;
          size = config.home.pointerCursor.size;
        };

        overview = {
          zoom = 0.5;
          workspace-shadow = {
            softness = 40;
            spread = 10;
            offset = {
              x = 0;
              y = 10;
            };
          };
        };

        prefer-no-csd = true;
        hotkey-overlay.skip-at-startup = true;
        clipboard = {
          disable-primary = true;
        };

      };
    };

  };
}
