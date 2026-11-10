{
  flake.modules.homeManager."desktop.niri" = {

    wayland.windowManager.niri.settings =
      _:
      let
        browser = "^(firefox|chrome|chromium|brave|vivaldi|opera|safari|edge|zen).*";
      in
      {
        _children = [
          {
            window-rule._children = [
              {
                match._props = {
                  app-id = "^(code|wezterm|jetbrains-pycharm|jetbrains-goland).*";
                };
              }
              { open-on-workspace = "1"; }
            ];
          }
          {
            window-rule._children = [
              {
                match._props = {
                  app-id = browser;
                };
              }
              { open-on-workspace = "2"; }
            ];
          }
          {
            window-rule._children = [
              {
                match._props = {
                  app-id = "^(com.obsproject.Studio).*";
                };
              }
              { open-on-workspace = "4"; }
            ];
          }
          {
            window-rule._children = [
              {
                match._props = {
                  app-id = "^(QQ|wechat|com.alibabainc.dingtalk|wemeetapp|Bytedance-feishu).*";
                };
              }
              { open-on-workspace = "4"; }
            ];
          }
        ];

        binds = {
          "Mod+1".focus-workspace = [ 1 ];
          "Mod+2".focus-workspace = [ 2 ];
          "Mod+3".focus-workspace = [ 3 ];
          "Mod+4".focus-workspace = [ 4 ];
          "Mod+5".focus-workspace = [ 5 ];

          "Mod+Shift+h".move-column-left = { };
          "Mod+Shift+l".move-column-right = { };
          "Mod+Shift+j".move-window-down = { };
          "Mod+Shift+k".move-window-up = { };

          "Mod+Shift+1".move-window-to-workspace = [ 1 ];
          "Mod+Shift+2".move-window-to-workspace = [ 2 ];
          "Mod+Shift+3".move-window-to-workspace = [ 3 ];
          "Mod+Shift+4".move-window-to-workspace = [ 4 ];
          "Mod+Shift+5".move-window-to-workspace = [ 5 ];
        };
      };

  };
}
