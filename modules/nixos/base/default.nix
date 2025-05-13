{ lib, self, ... }:
{
  imports = self.importModule' ./. ++ [
    self.baseModules

    ../desktop
  ];
}
