{ config, lib, ... }:
let
  cfg = config.profiles.desktop.kde;
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
        lookAndFeel = "com.github.vinceliuice.WhiteSur-dark";
        windowDecorations = {
          library = "org.kde.kwin.aurorae"; # 窗口装饰
          theme = "__aurorae__svg__WhiteSur-dark";
        };
      };
    };
  };
}
