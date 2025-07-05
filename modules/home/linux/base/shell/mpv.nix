{ pkgs, ... }:
{
  programs.mpv = {
    scripts = [ pkgs.mpvScripts.mpris ];
  };
  xdg.mimeApps.defaultApplications = {
    "audio/*" = [ "mpv.desktop" ];
    "video/*" = [ "mpv.desktop" ];
  };
}
