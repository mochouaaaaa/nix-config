{
  lib,
  pkgs,
  config,
  ...
}:
{

  imports = lib.importModule' ./.;

  config = lib.mkIf (!config.programs.wsl.enable) {

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
