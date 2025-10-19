{ lib, config, ... }:
let
  cfg = config.programs.dankMaterialShell;
in
{

  config = lib.mkIf (cfg.enable) {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          "$mod, Space, exec, dms ipc call spotlight toggle"
          "$mod, P, exec, dms ipc call clipboard toggle"
          "$mod, comma, exec, dms ipc call settings toggle"
          "$mod CTRL, q, exec, dms ipc call lock lock"
        ];
        bindl = [
          ", XF86AudioRaiseVolume, exec, dms ipc call audio increment 3"
          ", XF86AudioLowerVolume, exec, dms ipc call audio decrement 3"
          ", XF86AudioMute, exec, dms ipc call audio mute"
          ", XF86AudioMicMute, exec, dms ipc call audio micmute"

          ", XF86MonBrightnessUp, exec, dms ipc call brightness increment 5"
          ", XF86MonBrightnessDown, exec, dms ipc call brightness decrement 5"
        ];
        layerrule = [
          "blur, quickshell:bar"
        ];
      };
    };
  };
}
