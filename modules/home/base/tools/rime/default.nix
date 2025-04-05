{
  self,
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = self.mylib.scanPaths ./.;
}
