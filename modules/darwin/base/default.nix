{ self, ... }:
{
  imports = (self.mylib.scanPaths ./.) ++ [
    self.baseModules
    ../tools
  ];
}
