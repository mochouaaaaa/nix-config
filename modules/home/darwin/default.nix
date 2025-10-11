{ lib, self, ... }:
{
  imports = lib.importModule' ./. ++ [
    self.homeModules.base
  ];
}
