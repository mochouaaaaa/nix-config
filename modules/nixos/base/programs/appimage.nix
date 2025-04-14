{ pkgs, ... }:
{
  programs.appimage = {
    enable = true;
    package = pkgs.appimage-run.override {
      extraPkgs = pkgs: [
        pkgs.ffmpeg
        pkgs.imagemagick
      ];
    };
    binfmt = true;
  };
}
