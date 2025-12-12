{ lib, config, ... }:
let
  cfg = config.programs.dankMaterialShell;
  cfgHyprland = config.modules'.desktop.hyprland;
in
{

  config = lib.mkIf (cfg.enable && cfgHyprland.enable) {

    modules'.desktop.services.vicinae.enable = lib.mkForce false;

    modules'.desktop.hyprland = {
      settings = {
        media = [ ];
        brightness = [
          ", XF86MonBrightnessUp, exec, dms ipc call brightness increment 5"
          ", XF86MonBrightnessDown, exec, dms ipc call brightness decrement 5"
        ];
        volume = [
          ", XF86AudioRaiseVolume, exec, dms ipc call audio increment 3"
          ", XF86AudioLowerVolume, exec, dms ipc call audio decrement 3"
        ];
        clipboard = "$mod, P, exec, dms ipc call clipboard toggle";
        launcher = "$mod, Space, exec, dms ipc call spotlight toggle";
        lock = "$mod CTRL, q, exec, dms ipc call lock lock";
        shell-settings = "$mod, comma, exec, dms ipc call settings toggle";
      };
    };
    wayland.windowManager.hyprland = {
      settings = {
        decoration = lib.mkForceRecursive {
          shadow = {
            enabled = true;
            range = 30;
            render_power = 5;
            offset = "0 5";
            color = "rgba(00000070)";
          };
          blur = {
            enabled = true;
            size = 10;
            passes = 4;

            ignore_opacity = true;
            new_optimizations = true;
            xray = false;

            noise = 0.02;
            contrast = 1.1;
            vibrancy = 0.2;
            vibrancy_darkness = 0.3;
          };
          rounding = 12;
          active_opacity = 1.0;
          inactive_opacity = 0.9;
        };
        bindl = [
          ", XF86AudioMute, exec, dms ipc call audio mute"
          ", XF86AudioMicMute, exec, dms ipc call audio micmute"
        ];
        "$blur_layer" = "dms:(color-picker|clipboard|spotlight|settings)";
        layerrule = [
          "animation slide right, dms:control-center"
          "animation slide top, dms:dms:workspace-overview"

          "noanim, ^(quickshell)$"
        ];
      };
    };
  };
}
