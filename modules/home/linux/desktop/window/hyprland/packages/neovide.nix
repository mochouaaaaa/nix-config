{
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        windowrule = [
          "opacity 0.78, class:^(neovide)$"
        ];

        layerrule = [
          #neovide
          "blur, class:^(neovide)$"
        ];
      };
    };
  };
}
