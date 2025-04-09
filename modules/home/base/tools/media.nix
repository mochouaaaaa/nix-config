{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    ffmpeg-full
    ffmpegthumbnailer
    # images
    viu # Terminal image viewer with native support for iTerm and Kitty
    imagemagick
    graphviz
  ];
}
