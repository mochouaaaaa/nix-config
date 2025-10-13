{
  lib,
  config,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
  cfgCaelestia = config.modules'.desktop.shell.caelestia;
in
{
  imports = lib.importModule' ./.;

  config = lib.mkIf (cfg.enable && cfgCaelestia.enable) {

    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          "$mod,Space,global,caelestia:launcher"
          "$mod CTRL, q, global, caelestia:lock"

          "$mod CTRL, S, exec, caelestia screenshot -r -f"
          "$mod CTRL, A, exec, caelestia screenshot --region -f"
          "$mod, P, exec, caelestia clipboard"
        ];
        bindl = [
          ", XF86MonBrightnessUp, global, caelestia:brightnessUp"
          ", XF86MonBrightnessDown, global, caelestia:brightnessDown"

          ", XF86AudioPlay, global, caelestia:mediaToggle"
          ", XF86AudioPause, global, caelestia:mediaToggle"
          ", XF86AudioNext, global, caelestia:mediaNext"
          ", XF86AudioPrev, global, caelestia:mediaPrev"
          ", XF86AudioStop, global, caelestia:mediaStop"
        ];
      };
    };

  };
}
