{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules'.packages.tencent.wechat;
  isdekstop = config.programs.desktop.enable;
in
{
  options.modules'.packages.tencent = {
    wechat = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable WeChat.";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.wechat-uos;
      };
    };
  };

  config = lib.mkIf (cfg.enable && isdekstop) {
    home.packages = [ cfg.package ];
  };
}
