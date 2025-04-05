{ self, ... }:
{
  imports = self.mylib.scanPaths ./. ++ [ ../../base.nix ];
}
