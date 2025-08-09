{
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.packages.rime;
  rime-data = cfg.data-package;
in
{
  config = {
    modules'.packages.rime.extraFiles = lib.mkBefore [
      {
        name = "squirrel.custom.yaml";
        data = ''
          patch:
            "menu/page_size": 9
            "style/candidate_list_layout": linear
            "style/translucency": true

            # 特定App默认中/英文输入
            app_options:
              com.apple.Spotlight: # 聚焦搜索
                ascii_mode: true # true默认英文,false默认中文
              com.runningwithcrayons.Alfred: # alfred
                ascii_mode: true
              com.apple.Terminal: # 终端
                ascii_mode: true
                ascii_punct: true
              com.github.wez.wezterm:
                ascii_mode: true
                ascii_punct: true
              net.kovidgoyal.kitty:
                ascii_mode: true
                ascii_punct: true
              com.microsoft.VSCode: # Visual Studio Code
                ascii_mode: true
                ascii_punct: true # 中文状态输出英文标点(半角)
              com.neovide.neovide:
                ascii_mode: true
                ascii_punct: true
              com.tencent.Lemon: # 腾讯柠檬
                ascii_mode: true
              com.apple.dt.Xcode: # Xcode
                ascii_mode: true
              com.nektony.App-Cleaner-SII: # App Cleaner & Uninstaller
                ascii_mode: true
              com.xunyong.hapigo: # hapigo
                ascii_mode: true
              com.termius-dmg.mac: # termius
                ascii_mode: true
              com.raycast.macos: # Raycast
                ascii_mode: true
              com.postmanlabs.mac: # postman
                ascii_mode: true
              com.jetbrains.intellij: # idea
                ascii_mode: true
              com.jetbrains.pycharm:
                vim_mode: true
                ascii_mode: true
        '';
      }
    ];

    home.file = {
      "Library/Rime" = {
        # source = RimeTheme;
        source = "${rime-data}/share/rime-data";
        recursive = true;
        force = true;
      };
    };
  };
}
