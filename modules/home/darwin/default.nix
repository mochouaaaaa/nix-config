{ self, ... }:
{
  imports = self.importModule' ./. ++ [
    self.homeModules.base.home
    self.homeModules.base.core
    self.homeModules.base.tools
  ];
}
