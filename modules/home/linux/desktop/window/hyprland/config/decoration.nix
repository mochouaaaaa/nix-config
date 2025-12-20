{
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {

        decoration = {
          rounding = 7;
          # active_opacity = 0.78;
          # inactive_opacity = 0.78;

          blur = {
            enabled = true;
            size = 6;
            passes = 4;
            ignore_opacity = true;
            new_optimizations = true;
            special = true;
            popups = true;

            noise = 0.02;
            contrast = 1.1;
            vibrancy = 0.2;
            vibrancy_darkness = 0.3;
            xray = false;
          };
          shadow = {
            enabled = true;
            range = 30;
            render_power = 3;
            color = "rgba(00000040)";
          };
        };

      };
    };
  };
}
