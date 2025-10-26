{ config, lib, ... }:
let

  cfg = config.modules'.desktop.niri;
  browser = "^(firefox|chrome|chromium|brave|vivaldi|opera|safari|edge|zen).*";
in
{
  config = lib.mkIf cfg.enable {

    programs.niri.settings = {

      workspaces = {
        "1" = { };
        "2" = { };
        "3" = { };
        "4" = { };
        "5" = { };
        # "6" = { };
      };

      window-rules = [
        {
          matches = [ { app-id = "^(code|wezterm|jetbrains-pycharm|jetbrains-goland).*"; } ];
          open-on-workspace = "1";
        }
        {
          matches = [
            {
              app-id = browser;
            }
          ];
          open-on-workspace = "2";
        }
        {
          matches = [
            {
              app-id = "^(com.obsproject.Studio).*";
            }
          ];
          open-on-workspace = "4";
        }
        {
          matches = [
            {
              app-id = "^(QQ|wechat|com.alibabainc.dingtalk|wemeetapp|Bytedance-feishu).*";
            }
          ];
          open-on-workspace = "4";
        }
      ];

      binds = {
        "Mod+1".action.focus-workspace = "1";
        "Mod+2".action.focus-workspace = "2";
        "Mod+3".action.focus-workspace = "3";
        "Mod+4".action.focus-workspace = "4";
        "Mod+5".action.focus-workspace = "5";
        # "Mod+6".action.focus-workspace = "6";

        "Mod+Shift+1".action.move-window-to-workspace = "1";
        "Mod+Shift+2".action.move-window-to-workspace = "2";
        "Mod+Shift+3".action.move-window-to-workspace = "3";
        "Mod+Shift+4".action.move-window-to-workspace = "4";
        "Mod+Shift+5".action.move-window-to-workspace = "5";
        # "Mod+Shift+6".action.move-window-to-workspace = "6";
      };
    };
  };
}
