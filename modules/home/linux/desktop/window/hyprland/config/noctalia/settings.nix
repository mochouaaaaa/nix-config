{
  lib,
  config,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
  cfgNoctalia = config.modules'.desktop.shell.noctalia;
in
{
  config = lib.mkIf (cfg.enable && cfgNoctalia.enable) {

    modules'.desktop.hypridle.lock_cmd = "noctalia-shell ipc call lockScreen lock";

    modules'.desktop.hyprland = {
      settings = {
        media = [
          ", XF86AudioPlay, exec, noctalia-shell ipc call media playPause"
          ", XF86AudioNext, exec, noctalia-shell ipc call media next"
          ", XF86AudioPrev, exec, noctalia-shell ipc call media previous"
          ", XF86AudioMute, exec, noctalia-shell ipc call volume muteOutput"
        ];
        brightness = [
          ", XF86MonBrightnessUp, exec, noctalia-shell ipc call brightness increase" # f2
          ", XF86MonBrightnessDown, exec, noctalia-shell ipc call brightness decrease" # f1
        ];
        volume = [
          ", XF86AudioRaiseVolume, exec, noctalia-shell ipc call volume increase" # f12
          ", XF86AudioLowerVolume, exec, noctalia-shell ipc call volume decrease" # f11
        ];
        lock = "$mod CTRL, q, exec, noctalia-shell ipc call lockScreen lock";
        shell-settings = "$mod, comma, exec, noctalia-shell ipc call settings toggle";
      };
    };
    wayland.windowManager.hyprland = {
      settings = {
        decoration = lib.mkForceRecursive {
          rounding = 15;
        };
        layerrule = [
          "blur, noctalia-.*"
          "ignorezero, noctalia-.*"
        ];
      };
    };

  };
}
