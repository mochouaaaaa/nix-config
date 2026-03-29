{
  config,
  lib,
  pkgs,
  ...
}:
{

  config = lib.mkIf (config.profiles.desktop.enable) {

    programs.mpv = {
      scripts = [
        pkgs.mpvScripts.mpris
      ];
    };
    xdg.mimeApps.defaultApplicationPackages = [ config.programs.mpv.package ];
  };
}
