{ self, ... }:
{
  imports = self.mylib.scanPaths ./. ++ [ ../desktop ];
}
