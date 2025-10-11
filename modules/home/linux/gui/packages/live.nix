{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules'.packages.live;
  isdesktop = config.programs.desktop.enable;
in
{
  options.modules'.packages.live = {
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
        default = pkgs.wiliwili.overrideAttrs (oldAttrs: {
          src = pkgs.fetchFromGitHub {
            owner = "xfangfang";
            repo = "wiliwili";
            rev = "v1.5.2";
            fetchSubmodules = true;
            hash = "sha256-lcHKbEYlOznu9WhWX7ZoOCnxr6h/AJCLbjLmc2ZZTbg=";
          };
        });
      };
    };
  };

  config = {
    home.packages =
      with pkgs;
      [
        kooha # 录制屏幕 GIF图
      ]
      ++ lib.optionals (cfg.wiliwili.enable && !isdesktop) [ cfg.wiliwili.package ]
      ++ lib.optionals (cfg.hypontix.enable && !isdesktop) [ cfg.hypontix.package ]
      ++ lib.optionals (cfg.simple-live-app.enable && !isdesktop) [ cfg.simple-live-app.package ];
  };
}
