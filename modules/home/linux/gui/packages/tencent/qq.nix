{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.packages.tencent.qq;
  isdekstop = config.programs.desktop.enable;
in
{
  options.modules'.packages.tencent = {
    qq = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable Tencent QQ.";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.qq;
      };
    };
  };

  config = lib.mkIf (cfg.enable && isdekstop) {
    home.packages = [ cfg.package ];
  };
}
