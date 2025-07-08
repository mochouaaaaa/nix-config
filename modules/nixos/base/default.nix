{ lib, self, ... }:
{
  imports = lib.importModule' ./. ++ [
    ../desktop
  ];
}
