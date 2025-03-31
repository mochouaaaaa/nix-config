{defaultConfig, ...}: {
  home.file = {
    "Library/Rime/default.custom.yaml" = {
      text = defaultConfig;
    };
    "Library/Rime/squirrel.custom.yaml" = {
      text = ''
        patch:
          "menu/page_size": 9
          "style/candidate_list_layout": linear
          "style/translucency": true

          "key_binder/bindings":
            # Emacs 风格的快捷键
            - { when: paging, accept: Super_L+k, send: Page_Up } # 翻页
            - { when: paging, accept: Super_L+j, send: Page_Down }

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
    };
  };
}
