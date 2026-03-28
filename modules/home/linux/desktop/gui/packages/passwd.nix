{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfgDesktop = config.profiles.desktop;
  cfg = config.profiles.packages;
in
{
  options.profiles.packages = {
    authenticator = {
      enable = lib.mkEnableOption "Authenticator" // {
        default = cfgDesktop.gnome.enable && cfgDesktop.hyprland.enable;
      };
      package = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [
          pkgs.authenticator
        ];
      };
    };
  };

  config = lib.mkIf (config.profiles.desktop.enable) {
    home.packages = [
      pkgs.ente-auth
    ]
    ++ lib.optionals (cfg.authenticator.enable) cfg.authenticator.package;
  };
}
