{
  lib,
  pkgs,
  ...
}:
{
  imports = lib.importModule' ./.;

  config = lib.mkIf pkgs.stdenv.isLinux {
    targets.genericLinux.enable = true;
  };
}
