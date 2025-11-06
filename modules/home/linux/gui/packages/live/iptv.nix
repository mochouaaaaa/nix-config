{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules'.packages.live.iptv;
  isdesktop = config.programs.desktop.enable;
in
{
  options.modules'.packages.live = {
    iptv = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "IPTV.";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.hypnotix;
      };
    };
  };

  config = lib.mkIf (cfg.enable && isdesktop) {
    home.packages = [
      cfg.package
    ];
  };
}
