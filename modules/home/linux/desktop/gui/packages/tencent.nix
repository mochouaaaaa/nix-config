{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.profiles.packages.tencent;
  isDesktop = config.profiles.desktop.enable;
  cfgDesktop = config.profiles.desktop;
in
{
  options.profiles.packages.tencent = {
    matrix.enable = lib.mkOption {
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

  config = lib.mkIf isDesktop (
    lib.mkMerge [

      {
        home.packages =
          with pkgs;
          [
          ]
          ++ lib.optionals cfg.matrix.enable [
            # element-desktop
            fractal
            # fluffychat
          ]
          ++ lib.optionals cfg.dingding.enable [ nur.repos.xddxdd.dingtalk ]
          ++ lib.optionals cfg.feishu.enable [ feishu ]
          ++ lib.optionals cfg.qq.enable [ qq ]
          ++ lib.optionals cfg.wechat.enable [ wechat-uos ]
          ++ lib.optionals cfg.wemeet.enable [ wemeet ];
      }

      (lib.mkIf (cfgDesktop.hyprland.enable) {
        wayland.windowManager.hyprland = {
          settings = {
            bind = [
              "$mod CTRL, 3, togglespecialworkspace, wechat"
              "$mod CTRL, 4, togglespecialworkspace, matrix"
            ];
            windowrule = [
              "workspace special:wechat, match:class discord|equibop|vesktop|whatsapp|qq|dingtalk"
              "workspace special:matrix, match:class org.gnome.Fractal|fluffychat|Element"
            ];
          };
        };
      })
    ]
  );
}
