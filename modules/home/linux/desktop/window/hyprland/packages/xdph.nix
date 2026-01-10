{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "hypr/xdph.conf".text = ''
        screencopy{
            max_fps = 60
            allow_token_by_default=true
        }
      '';
    };
  };
}
