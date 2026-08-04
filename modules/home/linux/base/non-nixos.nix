{
  lib,
  pkgs,
  config,
  ...
}:
{
  config = lib.mkIf (pkgs.stdenv.hostPlatform.isLinux && config.profiles.desktop.enable) {
    targets.genericLinux.enable = true;
  };
}
