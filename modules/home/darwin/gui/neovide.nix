{ lib, ... }:
{
  programs.neovide = {
    enable = false;
    settings = {
      frame = lib.mkForce "transparent";
    };
  };
}
