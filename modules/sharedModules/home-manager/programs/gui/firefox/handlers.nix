{
  lib,
  pkgs,
  config,
  username,
  ...
}:
let
  cfg = config.programs.firefox;
in
{
  config = lib.mkIf cfg.enable {

    programs.firefox.profiles.${username}.handlers = {
      mimeTypes = {
        "application/pdf" = {
          action = 1; # 直接下载而不预览
        };
        "application/zip" = {
          action = 1; # 总是询问
        };
      };
    };

  };
}
