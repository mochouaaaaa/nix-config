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
  imports = lib.importModule' ./.;

  config = lib.mkIf (cfg.enable && cfgNoctalia.enable) {

    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          "$mod,Space, exec, noctalia-shell ipc call launcher toggle"
          "$mod CTRL, q, exec, noctalia-shell ipc call lockScreen toggle"

          "$mod CTRL, S, exec, grimblast --freeze copysave active"
          "$mod CTRL, A, exec, grimblast --freeze copysave area"
          "$mod, P, exec, noctalia-shell ipc call launcher clipboard"
          "$mod, comma, exec, noctalia-shell ipc call settings toggle"

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
