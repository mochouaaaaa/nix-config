{
  lib,
  pkgs,
  config,
  ...
}:
{

  config = lib.mkIf (!config.programs.wsl.enable) {

    home.packages = [
      pkgs.jetbra-free
    ];

  };
}
