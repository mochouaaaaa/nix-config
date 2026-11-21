{
  flake.modules.homeManager."desktop.niri" =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {

      xdg.configFile."niri/blur.kdl" = {
        enable = false;
        text = "";
      };

      wayland.windowManager.niri = {
        settings = {
          _children = [
            # {
            #   include = {
            #     _props.optional = true;
            #     _args = [ "blur.kdl" ];
            #   };
            # }
          ];

          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

          input = {
            keyboard = {
              xkb.layout = "us";
              repeat-delay = 200;
              repeat-rate = 50;
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
            xcursor-theme = config.home.pointerCursor.name;
            xcursor-size = config.home.pointerCursor.size;
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
