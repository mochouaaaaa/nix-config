{
  lib,
  pkgs,
  config,
  ...
}:
{

  config = lib.mkIf (config.profiles.desktop.enable) {

    programs.mpv = {
      enable = true;

      defaultProfiles = [ "gpu-hq" ];
      config = {
        osc = "no";
      };
      bindings = {
        WHEEL_LEFT = "seek 30";
        WHEEL_RIGHT = "seek -30";
        UP = "add volume +5";
        DOWN = "add volume -5";
      };
      extraInput = ''
        esc         quit                        #! Quit
      '';
      scripts = [
        pkgs.mpvScripts.modernz
      ];
    };

  };
}
