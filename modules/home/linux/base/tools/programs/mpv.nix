{ pkgs, ... }:
{
  programs.mpv = {
    scripts = [ pkgs.mpvScripts.mpris ];
  };
}
