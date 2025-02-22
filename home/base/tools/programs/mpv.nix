{pkgs, ...}: {
  programs = {
    mpv = {
      enable = true && pkgs.stdenv.isLinux;
      defaultProfiles = ["gpu-hq"];
      scripts = [pkgs.mpvScripts.mpris];
    };
  };
}
