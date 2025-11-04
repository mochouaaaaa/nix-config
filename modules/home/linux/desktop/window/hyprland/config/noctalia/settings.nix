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

    modules'.desktop.services.vicinae.enable = lib.mkForce true;
    modules'.desktop.hypridle.lock_cmd = "noctalia-shell ipc call lockScreen lock";

    wayland.windowManager.hyprland = {
      custom_settings = {
        media = [
          ", XF86AudioPlay, exec, noctalia-shell ipc call media playPause"
          ", XF86AudioNext, exec, noctalia-shell ipc call media next"
          ", XF86AudioPrev, exec, noctalia-shell ipc call media previous"
          ", XF86AudioMute, exec, noctalia-shell ipc call volume muteOutput"
        ];
        brightness = [
          ", XF86MonBrightnessUp, exec, noctalia-shell ipc call brightness increase"
          ", XF86MonBrightnessDown, exec, noctalia-shell ipc call brightness decrease"
        ];
        volume = [
          ", XF86AudioRaiseVolume, exec, noctalia-shell ipc call volume increase"
          ", XD86AudioLowerVolume, exec, noctalia-shell ipc call volume decrease"
        ];
        # clipboard = "$mod, P, exec, noctalia-shell ipc call launcher clipboard";
        # launcher = "$mod, Space, exec, noctalia-shell ipc call launcher toggle";
        lock = "$mod CTRL, q, exec, noctalia-shell ipc call lockScreen lock";
        shell-settings = "$mod, comma, exec, noctalia-shell ipc call settings toggle";
      };
      settings = {
        layerrule = [
          "blur, noctalia-bar"
          "ignorezero, noctalia-bar"
        ];
      };
    };

  };
}
