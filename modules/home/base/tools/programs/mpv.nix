{ pkgs, ... }:
{
  programs = {
    mpv = {
      enable = true;
      package = pkgs.mpv-unwrapped;
      defaultProfiles = [ "gpu-hq" ];
      # scripts = [ pkgs.mpvScripts.mpris ];
    };
  };
}
