{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.modules'.packages;
in
{
  options.modules'.packages = {
    bitwarden = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      package = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [
          pkgs.bitwarden-cli
          pkgs.bitwarden-desktop
        ];
      };
    };
  };

  config = {
    home.packages = lib.optionals (cfg.bitwarden.enable && !config.programs.wsl.enable) cfg.bitwarden.package;
  };
}
