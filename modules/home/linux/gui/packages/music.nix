{ pkgs, ... }:
{
  home.packages = with pkgs; [
    spotify
    lx-music-desktop
  ];
}
