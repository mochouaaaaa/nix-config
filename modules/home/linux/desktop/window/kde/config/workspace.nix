{ config, lib, ... }:
let
  cfg = config.modules'.desktop.kde;
in
{
  config = lib.mkIf cfg.enable {
    programs.plasma = {
      workspace = {
        clickItemTo = "select"; # 点击选择文件 open
        theme = "WhiteSur-dark"; # 主题
        colorScheme = "WhiteSurDark"; # 配色方案
        cursor = {
          theme = "WhiteSur Cursors"; # 光标主题
          size = 36;
        }; # 光标
      };
    };
  };
}
