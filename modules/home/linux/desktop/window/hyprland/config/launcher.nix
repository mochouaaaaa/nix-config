{
  lib,
  config,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
in
{

  config = lib.mkIf (cfg.enable) {
    modules'.desktop.services.vicinae.enable = true;

    wayland.windowManager.hyprland = {
      settings = {
        layerrule = [
          "blur,vicinae"
          "ignorealpha 0, vicinae"
        ];
        bind = [
          # "$mod,Space, exec, noctalia-shell ipc call launcher toggle"
          "$mod,Space, exec, vicinae toggle"

          "$mod, P, exec, vicinae vicinae://extensions/vicinae/clipboard/history"
        ];
      };
    };

  };
}
