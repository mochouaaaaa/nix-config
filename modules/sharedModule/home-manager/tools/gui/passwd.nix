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
        default = true;
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
    home.packages = [
    ] ++ lib.optionals (cfg.bitwarden.enable) cfg.bitwarden.package;
  };
}
