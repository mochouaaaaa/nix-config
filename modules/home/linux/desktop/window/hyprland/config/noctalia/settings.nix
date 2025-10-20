{
  lib,
  config,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
  cfgNoctalia = config.modules'.desktop.shell.noctalia;
  cfgLauncher = config.modules'.desktop.services.vicinae;
in
{
  config = lib.mkIf (cfg.enable && cfgNoctalia.enable) {

    modules'.desktop.services.vicinae.enable = lib.mkForce true;

    wayland.windowManager.hyprland = {
      settings = {
        layerrule = [
          "blur, noctalia-bar"
          "ignorezero, noctalia-bar"
        ];
        bind = [
          "$mod CTRL, q, exec, noctalia-shell ipc call lockScreen toggle"
          "$mod CTRL, S, exec, grimblast --freeze copysave active"
          "$mod CTRL, A, exec, grimblast --freeze copysave area"
          "$mod, comma, exec, noctalia-shell ipc call settings toggle"
        ]
        ++ lib.optionals (!cfgLauncher.enable) [
          "$mod, Space, exec, noctalia-shell ipc call launcher toggle"
          "$mod, P, exec, noctalia-shell ipc call launcher clipboard"
        ];
        bindel = [
          ", XF86AudioRaiseVolume, exec, noctalia-shell ipc call volume increase"
          ", XD86AudioLowerVolume, exec, noctalia-shell ipc call volume decrease"
          ", XF86MonBrightnessUp, exec, noctalia-shell ipc call brightness increase"
          ", XF86MonBrightnessDown, exec, noctalia-shell ipc call brightness decrease"
        ];
        bindl = [
          ", XF86AudioMute, exec, noctalia-shell ipc call volume muteOutput"

        ];
      };
    };

  };
}
