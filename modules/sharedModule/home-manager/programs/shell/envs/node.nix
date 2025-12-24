{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules'.packages.envs.node;
in
{

  config = lib.mkIf cfg.enable {

    home.packages = [
      pkgs.nodejs_25
    ];

    programs = {
      yarn = {
        enable = true;
      };
      npm = {
        enable = true;
        package = pkgs.nodejs_25;
        settings = {
          color = true;
          include = [
            "dev"
            "prod"
          ];
          init-license = "MIT";
          prefix = "${config.home.homeDirectory}/.npm";
        };
      };

    };

  };
}
