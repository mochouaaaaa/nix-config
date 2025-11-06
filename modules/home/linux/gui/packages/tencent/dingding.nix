{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.packages.tencent.dingding;
  isdekstop = config.programs.desktop.enable;
in
{
  options.modules'.packages.tencent = {
    dingding = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable DingDing.";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.nur.repos.xddxdd.dingtalk;
      };
    };
  };

  config = lib.mkIf (cfg.enable && isdekstop) {
    home.packages = [ cfg.package ];
  };
}
