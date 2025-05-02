{ lib, ... }:
{
  homebrew = {
    taps = lib.mkAfter [
      # "iina/homebrew-mpv-iina"
    ];
    casks = lib.mkAfter [
      "iina+"
    ];
    brews = lib.mkAfter [
      # "iina/mpv-iina/mpv-iina"
    ];
  };
}
