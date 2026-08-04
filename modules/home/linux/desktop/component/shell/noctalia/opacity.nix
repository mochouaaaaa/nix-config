{ config, lib, ... }:
let
  cfg = config.profiles.desktop.shell.noctalia;
in
{
  config = lib.mkIf (cfg.enable) {
    programs.noctalia = {
      settings = {
        bar = {
          widgets.background_opacity = 0.62;
        };
        notification = {
          background_opacity = 0.62;
        };
        osd = {
          background_opacity = 0.62;
        };
        lockscreen = {
          blur_intensity = 0.62;
        };
      };
    };
  };
}
