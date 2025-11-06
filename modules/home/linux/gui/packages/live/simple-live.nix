{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules'.packages.live.simple-live-app;
  isdesktop = config.programs.desktop.enable;
in
{
  options.modules'.packages.live = {
    simple-live-app = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Simple live streaming app.";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.simple-live-app;
      };
    };
  };

  config = lib.mkIf (cfg.enable && isdesktop) {
    home.packages = [
      cfg.package
    ];
  };
}
