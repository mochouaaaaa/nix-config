{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.profiles.languages.envs.node;
in
{

  config = lib.mkIf cfg.enable {

    home.packages = [
      pkgs.nodejs_22
      # (pkgs.gemini-cli.override { nodejs = pkgs.nodejs_22; })
      pkgs.gemini-cli-bin
    ];

    programs = {
      yarn = {
        enable = true;
      };
      npm = {
        enable = true;
        package = pkgs.nodejs_22;
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
