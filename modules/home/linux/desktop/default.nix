{
  self,
  lib,
  config,
  ...
}:
let
  cfgDesktop = config.modules.desktop;
in
{
  imports = self.mylib.scanPaths ./.;
}
