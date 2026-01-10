{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.profiles.packages;
in
{
  options.profiles.packages = {
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

  config = lib.mkIf (cfg.bitwarden.enable && config.profiles.desktop.enable) {
    home.packages = cfg.bitwarden.package;
  };
}
