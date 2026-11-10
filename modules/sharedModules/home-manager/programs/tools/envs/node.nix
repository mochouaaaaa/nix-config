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
      pkgs.nodejs
    ]
    ++ (lib.optionals pkgs.stdenv.hostPlatform.isLinux) [
      pkgs.antigravity-cli
    ]
    ++ (lib.optionals pkgs.stdenv.hostPlatform.isDarwin) [
      pkgs.gemini-cli
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
