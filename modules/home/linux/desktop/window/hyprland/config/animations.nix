{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {

        decoration = {
          rounding = 10;

          active_opacity = 1.0;
          inactive_opacity = 1.0;
          fullscreen_opacity = 1.0;

          dim_inactive = true;
          dim_strength = 0.0; # 非活动窗口的亮度
          dim_special = 0.6;

          blur = {
            enabled = true;
            size = 6;
            passes = 2;
            ignore_opacity = true;
            new_optimizations = true;
            special = true;
            popups = true;
          };
        };

        animations = {
          enabled = true;

          bezier = [
            "wind, 0.05, 0.9, 0.1, 1.05"
            "winIn, 0.1, 1.1, 0.1, 1.1"
            "winOut, 0.3, -0.3, 0, 1"
            "liner, 1, 1, 1, 1"
            "overshot, 0.05, 0.9, 0.1, 1.05"
            "smoothOut, 0.5, 0, 0.99, 0.99"
            "smoothIn, 0.5, -0.5, 0.68, 1.5"
          ];

          animation = [
            "windows, 1, 6, wind, slide"
            "windowsIn, 1, 5, winIn, slide"
            "windowsOut, 1, 3, smoothOut, slide"
            "windowsMove, 1, 5, wind, slide"
            "border, 1, 1, liner"
            "fade, 1, 3, smoothOut"
            "workspaces, 1, 5, overshot"
          ];
        };

      };
    };
  };
}
