{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfgDesktop = config.modules'.desktop;
  cfg = config.modules'.packages;
in
{
  options.modules'.packages = {
    authenticator = {
      enable = lib.mkEnableOption "Authenticator" // {
        default = cfgDesktop.gnome.enable && cfgDesktop.hyprland.enable;
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
    home.packages = [
    ] ++ lib.optionals (cfg.authenticator.enable) cfg.authenticator.package;
  };
}
