{
  flake.modules.homeManager."desktop.niri" = { lib, pkgs, ... }: {

    xdg.configFile."niri/blur.kdl".text = ''
      blur {
          passes 2        // more passes = stronger blur (default: 3)
          offset 3.0      // sample distance per pass (default: 3.0)
          noise 0.03      // grain overlay (default: 0.02)
          saturation 1  // color saturation boost (default: 1.5)
      }

      // layer-rule {
      //     match namespace="vicinae"
      //     baba-is-float true
      // }


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

    wayland.windowManager.niri = {
      settings = {
        _children = [
          {
            include = {
              _props.optional = true;
              _args = [ "blur.kdl" ];
            };
          }
        ];

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        input = {
          keyboard = {
            xkb.layout = "us";
            repeat-delay = 200;
            repeat-rate = 40;
          };

          touchpad = {
            accel-speed = 0.2;
            tap = { };
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

          focus-ring.width = 2;
          always-center-single-column = true;
          center-focused-column = "always";
          background-color = "transparent";
        };

        cursor = {
          # theme = config.home.pointerCursor.name;
          # size = config.home.pointerCursor.size;
        };

        overview = {
          zoom = 0.5;

          workspace-shadow = {
            off = { };
            offset._props = {
              x = 0;
              y = 10;
            };
            softness = 40;
            spread = 10;
          };
        };

        prefer-no-csd = true;
        hotkey-overlay.skip-at-startup = true;
        clipboard.disable-primary = true;
      };
    };

  };
}
