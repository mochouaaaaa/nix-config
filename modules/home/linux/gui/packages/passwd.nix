{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.modules.packages;
in
{
  options.modules.packages = {
    bitwarden = {
      enable = lib.mkEnableOption "Bitwarden" // {
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
    authenticator = {
      enable = lib.mkEnableOption "Authenticator" // {
        default = true;
      };
      package = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [
          pkgs.authenticator
          pkgs.gnome-keyring
        ];
      };
    };
  };

  config = {
    home.packages =
      [
      ]
      ++ lib.optionals (cfg.bitwarden.enable) cfg.bitwarden.package
      ++ lib.optionals (cfg.authenticator.enable) cfg.authenticator.package;
  };
}
