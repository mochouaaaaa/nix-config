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

    xdg.configFile."niri/blur.kdl".text = ''
      blur {
          passes 2        // more passes = stronger blur (default: 3)
          offset 3.0      // sample distance per pass (default: 3.0)
          noise 0.03      // grain overlay (default: 0.02)
          saturation 1  // color saturation boost (default: 1.5)
      }

      layer-rule {
          match namespace="vicinae"
          baba-is-float true
      }


      window-rule {
          draw-border-with-background false
          clip-to-geometry true

          background-effect {
              xray false
              blur true
          }
      }

      layer-rule {
          match namespace="vicinae"

          place-within-backdrop true

          background-effect {
              xray false
              blur true
          }
      }

    '';
    programs.niri = {
      settings = {
        includes = [
          "blur.kdl"
        ];
        xwayland-satellite = {
          enable = true;
          path = lib.getExe pkgs.xwayland-satellite;
        };
        # debug = ''
        #   honor-xdg-activation-with-invalid-serial
        # '';
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
