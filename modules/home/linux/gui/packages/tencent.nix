{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.packages.tencent;
in
{
  options.modules'.packages.tencent = {
    qq = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable Tencent QQ.";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.qq;
      };
    };
    wechat = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable WeChat.";
      };
      package = lib.mkOption {
        type = lib.types.package;
#        default = pkgs.nixpaks.wechat-uos;
      };
    };
    wemeet = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable WeMeet.";
      };
      package = lib.mkOption {
        type = lib.types.package;
        # default = pkgs.nur.repos.linyinfeng.wemeet;
        default = pkgs.wemeet;
      };
    };
    dingding = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable DingDing.";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.nur.repos.xddxdd.dingtalk;
      };
    };
    feishu = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable Feishu.";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.feishu;
      };
    };
  };

  config = {
    home.packages =
      [ pkgs.element-desktop ]
      ++ lib.optionals cfg.qq.enable [ cfg.qq.package ]
#      ++ lib.optionals cfg.wechat.enable [ cfg.wechat.package ]
      ++ lib.optionals cfg.wemeet.enable [ cfg.wemeet.package ]
      ++ lib.optionals cfg.dingding.enable [ cfg.dingding.package ]
      ++ lib.optionals cfg.feishu.enable [ cfg.feishu.package ];
  };
}
