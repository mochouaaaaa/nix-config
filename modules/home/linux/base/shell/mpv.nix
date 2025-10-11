{
  config,
  lib,
  pkgs,
  ...
}:
{

  config = lib.mkIf (!config.programs.wsl.enable) {

    programs.mpv = {
      scripts = [
        pkgs.mpvScripts.mpris
      ];
    };
    xdg.mimeApps.defaultApplications = {
      "audio/*" = [ "mpv.desktop" ];
      "video/*" = [ "mpv.desktop" ];
    };

  };
}
