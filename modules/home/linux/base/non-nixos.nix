{
  lib,
  pkgs,
  config,
  ...
}:
{
  config = lib.mkIf (pkgs.stdenv.isLinux && config.profiles.desktop.enable) {
    targets.genericLinux.enable = true;
  };
}
