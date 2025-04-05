{ self, ... }:
{
  imports = self.mylib.scanPaths ./.;
}
