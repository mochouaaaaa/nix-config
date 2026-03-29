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
          action = "saveToDisk"; # 直接下载而不预览
        };
        "application/zip" = {
          action = "alwaysAsk"; # 总是询问
        };
      };
    };

  };
}
