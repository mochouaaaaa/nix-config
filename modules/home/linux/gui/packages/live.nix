{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.packages.live;
in
{
  options.modules.packages.live = {
    hypontix = {
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
    wiliwili = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "BiliBili.";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.wiliwili;
      };
    };
  };

  config = {

    home.packages =
      with pkgs;
      [
        kooha # 录制屏幕 GIF图
      ]
      ++ lib.optional cfg.wiliwili.enable [ cfg.wiliwili.package ]
      ++ lib.optional cfg.hypontix.enable [ cfg.hypontix.package ]
      ++ lib.optional cfg.simple-live-app.enable [ cfg.simple-live-app.package ];
  };
}
