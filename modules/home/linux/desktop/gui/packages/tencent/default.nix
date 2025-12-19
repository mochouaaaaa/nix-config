{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules'.packages.tencent;
  isDesktop = config.programs.desktop.enable;
in
{
  options.modules'.packages.tencent = {
    element.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable Element Desktop.";
    };
    dingding.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable DingTalk.";
    };
    feishu.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable Feishu.";
    };
    qq.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable Tencent QQ.";
    };
    wechat.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable WeChat (UOS).";
    };
    wemeet.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable Tencent Meeting (WeMeet).";
    };
  };

  config = lib.mkIf isDesktop {
    home.packages = with pkgs;
      [ ]
      ++ lib.optionals cfg.element.enable [ element-desktop ]
      ++ lib.optionals cfg.dingding.enable [ nur.repos.xddxdd.dingtalk ]
      ++ lib.optionals cfg.feishu.enable [ feishu ]
      ++ lib.optionals cfg.qq.enable [ qq ]
      ++ lib.optionals cfg.wechat.enable [ wechat-uos ]
      ++ lib.optionals cfg.wemeet.enable [ wemeet ];
  };
}
