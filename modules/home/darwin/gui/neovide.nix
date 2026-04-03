{ lib, ... }:
{
  programs.neovide = {
    package = null;
    settings = {
      frame = lib.mkForce "transparent";
    };
  };
}
