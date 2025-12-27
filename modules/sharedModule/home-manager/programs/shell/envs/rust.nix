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
      pkgs.rust-analyzer
      pkgs.rustfmt
      pkgs.rustup
    ];

    programs = {
      cargo = {
        enable = true;
      };
    };

  };
}
