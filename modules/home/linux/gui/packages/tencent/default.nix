{
  lib,
  pkgs,
  ...
}:
{
  imports = lib.importModule' ./.;

  home.packages = [ pkgs.element-desktop ];
}
