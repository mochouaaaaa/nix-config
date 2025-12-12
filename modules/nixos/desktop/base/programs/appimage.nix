{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.programs.desktop.enable) {

    programs.appimage = {
      enable = config.programs.desktop.enable;
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
