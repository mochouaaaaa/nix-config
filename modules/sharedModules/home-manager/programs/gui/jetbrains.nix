{
  lib,
  pkgs,
  config,
  ...
}:
{

  config = lib.mkIf (config.profiles.desktop.enable) {

    home.packages = [
      pkgs.jetbra-free
    ];

  };
}
