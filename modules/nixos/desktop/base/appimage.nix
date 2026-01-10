{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.profiles.desktop.enable) {

    programs.appimage = {
      enable = config.profiles.desktop.enable;
      package = pkgs.appimage-run.override {
        extraPkgs = pkgs: [
          pkgs.ffmpeg
          pkgs.imagemagick
        ];
      };
      binfmt = true;
    };

  };
}
