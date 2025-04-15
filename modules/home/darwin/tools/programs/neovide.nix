{ lib, ... }:
{
  programs.neovide = {
    settings = {
      frame = lib.mkForce "transparent";
    };
  };
}
