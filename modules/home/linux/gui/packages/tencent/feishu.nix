{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.packages.tencent.feishu;
  isdekstop = config.programs.desktop.enable;
in
{
  options.modules'.packages.tencent = {
    feishu = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable Feishu.";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.feishu;
      };
    };
  };

  config = lib.mkIf (cfg.enable && isdekstop) {
    home.packages = [ cfg.package ];
  };
}
