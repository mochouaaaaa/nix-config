{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules'.packages.envs.rust;
in
{

  config = lib.mkIf cfg.enable {

    home.packages = [
      pkgs.rustup
    ];

    programs = {
      cargo = {
        enable = true;
      };
    };

  };
}
