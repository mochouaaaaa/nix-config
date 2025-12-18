{
  lib,
  pkgs,
  config,
  ...
}:
{

  config = lib.mkIf (config.programs.desktop.enable) {

    home.packages = [
      pkgs.jetbra-free
    ];

  };
}
