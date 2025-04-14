{ pkgs, ... }:
{
  home.packages = with pkgs; [
    thunderbird-latest
    birdtray
  ];
}
