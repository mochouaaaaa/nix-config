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
          rounding = "$windowRounding";

          blur = {
            enabled = true;
            size = 6;
            passes = 2;
            ignore_opacity = true;
            new_optimizations = true;
            special = true;
            popups = true;
          };
          shadow = {
            enabled = "$shadowEnabled";
            range = "$shadowRange";
            render_power = "$shadowRenderPower";
            color = "$shadowColour";
          };
        };

      };
    };
  };
}
