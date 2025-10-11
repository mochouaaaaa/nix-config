{
  pkgs,
  lib,
  config,
  ...
}:
{

  config = lib.mkIf (!config.programs.wsl.enable) {

    home.packages = with pkgs; [
      ffmpeg-full
      ffmpegthumbnailer
      # images
      viu # Terminal image viewer with native support for iTerm and Kitty
      imagemagick
      graphviz
    ];

  };
}
