{ pkgs, lib, ... }:
{
  programs.mpv = {
    enable = lib.mkForce false;
    # package = pkgs.mpv-unwrapped;
  };
}
