{ lib, ... }:
{
  programs.neovide = {
    enable = lib.mkForce false;
    settings = {
      frame = lib.mkForce "transparent";
    };
  };
}
