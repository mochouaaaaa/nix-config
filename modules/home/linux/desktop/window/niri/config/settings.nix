{ config, lib, ... }:
let

  cfg = config.modules.desktop.niri;
in
{
  config = lib.mkIf cfg.enable {

    programs.niri.settings = {
      environment = {

        #environment-variables
        CLUTTER_BACKEND = "wayland";
        SDL_VIDEODRIVER = "wayland";
        # QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        QT_QPA_PLATFORM = "wayland;xcb";
        # GDK_DPI_SCALE = "1";
        # QT_SCALE_FACTOR = "1";
        # QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        XDG_CURRENT_DESKTOP = "niri";
        XDG_SESSION_TYPE = "wayland";

        "DISPLAY" = ":0";
        MOZ_ENABLE_WAYLAND = "1";

        # java
        _JAVA_AWT_WM_NONREPARENTING = "1";

        # firefox
        NIXOS_OZONE_WL = "1";
        MOZ_WEBRENDER = "1";

        # electron >28 apps (may help)
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
      };
      input = {
        keyboard = {

          xkb = {
            layout = "us";
          };

          repeat-delay = 200;
          repeat-rate = 40;

        };

        mod-key = "Super";

        workspace-auto-back-and-forth = true;
      };
      cursor = {
        size = 36;
      };

      animations.window-resize.custom-shader = ''
        vec4 resize_color(vec3 coords_curr_geo, vec3 size_curr_geo) {
          vec3 coords_next_geo = niri_curr_geo_to_next_geo * coords_curr_geo;

          vec3 coords_stretch = niri_geo_to_tex_next * coords_curr_geo;
          vec3 coords_crop = niri_geo_to_tex_next * coords_next_geo;

          // We can crop if the current window size is smaller than the next window
          // size. One way to tell is by comparing to 1.0 the X and Y scaling
          // coefficients in the current-to-next transformation matrix.
          bool can_crop_by_x = niri_curr_geo_to_next_geo[0][0] <= 1.0;
          bool can_crop_by_y = niri_curr_geo_to_next_geo[1][1] <= 1.0;

          vec3 coords = coords_stretch;
          if (can_crop_by_x)
              coords.x = coords_crop.x;
          if (can_crop_by_y)
              coords.y = coords_crop.y;

          vec4 color = texture2D(niri_tex_next, coords.st);

          // However, when we crop, we also want to crop out anything outside the
          // current geometry. This is because the area of the shader is unspecified
          // and usually bigger than the current geometry, so if we don't fill pixels
          // outside with transparency, the texture will leak out.
          //
          // When stretching, this is not an issue because the area outside will
          // correspond to client-side decoration shadows, which are already supposed
          // to be outside.
          if (can_crop_by_x && (coords_curr_geo.x < 0.0 || 1.0 < coords_curr_geo.x))
              color = vec4(0.0);
          if (can_crop_by_y && (coords_curr_geo.y < 0.0 || 1.0 < coords_curr_geo.y))
              color = vec4(0.0);

          return color;
        }
      '';
      prefer-no-csd = true;
      hotkey-overlay.skip-at-startup = true;

      # overview = {
      #   zoom = 0.25;
      # };
    };

  };
}
