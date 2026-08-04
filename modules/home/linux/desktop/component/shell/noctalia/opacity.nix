{ config, lib, ... }:
let
  cfg = config.profiles.desktop.shell.noctalia;
in
{
  config = lib.mkIf (cfg.enable) {
    programs.noctalia = {
      settings = {
        bar = {
          widgets.background_opacity = 0.68;
        };
        notification = {
          background_opacity = 0.68;
        };
        osd = {
          background_opacity = 0.68;
        };
        lockscreen = {
          blur_intensity = 0.68;
        };
      };
    };
  };
}
