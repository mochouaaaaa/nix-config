{ lib, config, ... }:
let
  cfg = config.programs.dankMaterialShell;
in
{

  config = lib.mkIf (cfg.enable) {

    modules'.desktop.services.vicinae.enable = lib.mkForce false;

    wayland.windowManager.hyprland = {
      custom_settings = {
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
      settings = {
        bindl = [
          ", XF86AudioMute, exec, dms ipc call audio mute"
          ", XF86AudioMicMute, exec, dms ipc call audio micmute"
        ];
        layerrule = [
          "blur, quickshell:bar"
        ];
      };
    };
  };
}
