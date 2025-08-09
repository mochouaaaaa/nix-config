{ config, lib, ... }:
let

  cfg = config.modules'.desktop.niri;
  browser = "^(firefox|chrome|chromium|brave|vivaldi|opera|safari|edge|zen).*";
in
{
  config = lib.mkIf cfg.enable {

    programs.niri.settings = {

      workspaces = {
        "code" = { };
        "browser" = { };
        "docs" = { };
        "tencent" = { };
        "steam" = { };
        "obs" = { };
      };

      window-rules = [
        {
          matches = [ { app-id = "^(code|wezterm|jetbrains-pycharm|jetbrains-goland).*"; } ];
          open-on-workspace = "code";
        }
        {
          matches = [
            {
              app-id = browser;
            }
          ];
          open-on-workspace = "browser";
        }
        {
          matches = [
            {
              app-id = "^(com.obsproject.Studio).*";
            }
          ];
          open-on-workspace = "obs";
        }
        {
          matches = [
            {
              app-id = "^(io.github.kukuruzka165.materialgram|QQ|wechat|com.alibabainc.dingtalk|wemeetapp|Bytedance-feishu).*";
            }
          ];
          open-on-workspace = "tencent";
        }
      ];

      binds = {
        "Mod+1".action.focus-workspace = "code";
        "Mod+2".action.focus-workspace = "browser";
        "Mod+3".action.focus-workspace = "docs";
        "Mod+4".action.focus-workspace = "tencent";
        "Mod+5".action.focus-workspace = "steam";
        "Mod+6".action.focus-workspace = "obs";

        "Mod+Shift+1".action.move-window-to-workspace = "code";
        "Mod+Shift+2".action.move-window-to-workspace = "browser";
        "Mod+Shift+3".action.move-window-to-workspace = "docs";
        "Mod+Shift+4".action.move-window-to-workspace = "tencent";
        "Mod+Shift+5".action.move-window-to-workspace = "steam";
        "Mod+Shift+6".action.move-window-to-workspace = "obs";
      };
    };
  };
}
