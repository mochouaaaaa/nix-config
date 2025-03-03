{
  pkgs,
  lib,
  myvars,
  config,
  defaultConfig,
  ...
}: let
  dotfiles = config.dotfiles;
  rimeConfig = "${dotfiles}/rime";

  fcitx5Config = pkgs.fetchFromGitHub {
    owner = "Mintimate";
    repo = "oh-my-rime";
    rev = "main";
    sha256 = "sha256-3EvPJVrnTJf9xn8I9CAUww/noMpzvg2+YUxabw9jS0o=";
  };

  cleanedFcitx5Config =
    pkgs.runCommand "cleaned-fcitx5-config" {
      buildInputs = [pkgs.coreutils];
    } ''
      mkdir -p $out

      find ${fcitx5Config} -name "*.yaml" \
          -not -name "README*.yaml" \
          -not -name "*terra*.yaml" \
          -not -name "*wubi*.yaml" \
          -not -name "*ibus*.yaml" \
          -not -name "*double_pinyin*.yaml" \
          -not -name "*t9*.yaml" \
          -exec cp -r -t $out {} +

      cp -r ${fcitx5Config}/dicts $out/
      cp -r ${fcitx5Config}/lua $out/
      cp -r ${fcitx5Config}/opencc $out/
      cp -r ${fcitx5Config}/plum $out/
      cp -r ${fcitx5Config}/preview $out/
      cp -r ${fcitx5Config}/tools $out/

    '';
in {
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5 = {
      fcitx5-with-addons = pkgs.kdePackages.fcitx5-with-addons;
      addons = with pkgs;
        [
          fcitx5-rime
          fcitx5-lua
          fcitx5-chinese-addons
        ]
        ++ lib.optionals (myvars.desktop.kde) [kdePackages.fcitx5-configtool]
        ++ lib.optionals (!myvars.desktop.kde) [fcitx5-configtool];
      waylandFrontend = true;
    };
  };

  xdg.dataFile = {
    "fcitx5/rime" = {
      source = cleanedFcitx5Config;
      recursive = true;
    };
    "fcitx5/themes" = {
      source = config.lib.file.mkOutOfStoreSymlink "${rimeConfig}/themes";
      recursive = true;
    };
    "fcitx5/rime/default.custom.yaml" = {
      text = defaultConfig;
    };
    "fcitx5/rime/fcitx5.custom.yaml" = {
      enable = true;
      text = ''
        patch:
          "menu/page_size": 9
          "style/candidate_list_layout": linear
          "style/translucency": true

          schema_list:
            - schema: rime_mint # 薄荷拼音
            - schema: rime_mint_flypy # 薄荷拼音-小鹤混输方案

          # dbus-send --print-reply=literal --dest=org.fcitx.Fcitx5 /controller org.fcitx.Fcitx.Controller1.DebugInfo
          # 特定App默认中/英文输入
          "app_options/wezterm":
            ascii_mode: true
            ascii_punct: true
          "app_options/kitty":
            ascii_mode: true
            ascii_punct: true
          "app_options/code frontend": # Visual Studio Code
            ascii_mode: true
            ascii_punct: true # 中文状态输出英文标点(半角)
          "app_options/neovide":
            ascii_mode: true
            ascii_punct: true
          "app_options/firefox": # postman
            ascii_mode: true
            ascii_punct: true
          "app_options/jetbrains.intellij": # idea
            ascii_mode: true
            ascii_punct: true
          "app_options/jetbrains-pycharm":
            ascii_mode: true
            ascii_punct: true
          "app_options/jetbrains-goland":
            ascii_mode: true
            ascii_punct: true
          "app_options/jetbrains-datagrip":
            ascii_mode: true
            ascii_punct: true
          ${lib.optionalString (myvars.desktop.kde) ''
          "app_options/org.kde.krunner.desktop":
              ascii_mode: true
              ascii_punct: true
          "app_options/org.kde.plasmashell":
              ascii_mode: true
              ascii_punct: true
        ''}
      '';
    };
  };

  xdg.configFile = {
    "fcitx5/profile" = {
      force = true;
      text = ''
        [Groups/0]
        # Group Name
        Name=Other
        # Layout
        Default Layout=us
        # Default Input Method
        DefaultIM=rime

        [Groups/0/Items/0]
        # Name
        Name=rime
        # Layout
        Layout=

        [GroupOrder]
        0=Other
      '';
    };
    "fcitx5/conf/classicui.conf" = {
      force = true;
      text = ''
        Vertical Candidate List=False
        PerScreenDPI=True
        WheelForPaging=True
        Font="Monaco Nerd Font 10"
        MenuFont="Monaco Nerd Font 10"
        TrayFont="Monaco Nerd Font 10"
        TrayOutlineColor=#000000
        TrayTextColor=#ffffff
        PreferTextIcon=False
        ShowLayoutNameInIcon=True
        UseInputMethodLangaugeToDisplayText=True
        Theme=macOS-dark
        DarkTheme=macOS-dark
        UseDarkTheme=False
        ForceWaylandDPI=0
        EnableFractionalScale=True
      '';
    };
    "fcitx5/conf/rime.conf" = {
      force = true;
      text = ''
        PreeditMode="Commit preview"
        InputState=No
        PreeditCursorPositionAtBeginning=True
        SwitchInputMethodBehavior="Commit commit preview"
        Deploy=
        Synchronize=
      '';
    };
    "fcitx5/conf/notifications.conf" = {
      force = true;
      text = ''
        [HiddenNotifications]
        0=fcitx-rime-deploy
      '';
    };
  };
}
