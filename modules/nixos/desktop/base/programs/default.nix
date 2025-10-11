{ lib, ... }:
{
  imports = lib.importModule' ./.;

  programs.wshowkeys.enable = true;
}
