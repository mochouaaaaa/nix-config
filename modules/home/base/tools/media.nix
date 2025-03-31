{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    ffmpeg-full
    # images
    viu # Terminal image viewer with native support for iTerm and Kitty
    imagemagick
    luajitPackages.magick
    graphviz
  ];
}
