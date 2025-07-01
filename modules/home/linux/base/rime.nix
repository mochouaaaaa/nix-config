{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfgDesktop = config.modules.desktop;

  rime-data = config.modules.packages.rime.data-package;

  fictx5-themes = pkgs.stdenv.mkDerivation {
    name = "fcitx5-themes-candlelight";

    src = pkgs.fetchFromGitHub {
      owner = "thep0y";
      repo = "fcitx5-themes-candlelight";
      rev = "d4146d3d3f7a276a8daa2847c3e5c08de20485da";
      sha256 = "sha256-/IdN69izB30rl1gswsXivYtpAeCUdahP7oy06XJXo0I=";
    };

    unpackPhase = "true";

    installPhase = ''
      mkdir -p $out/share/fcitx5/themes
      cp -r $src/* $out/share/fcitx5/themes
    '';
  };
in
{
  config = {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        fcitx5-with-addons = pkgs.libsForQt5.fcitx5-with-addons;
        addons = with pkgs; [
          (fcitx5-rime.override {
            rimeDataPkgs = [
              rime-data
            ];
          })
          fcitx5-lua
          fcitx5-gtk
          kdePackages.fcitx5-qt
          fcitx5-chinese-addons
        ];
        # ++ lib.optionals (!cfgDesktop.kde.enable) [ fcitx5-gtk ];
        waylandFrontend = true;
      };
    };

    home.sessionVariables = {
      QT_QPA_PLATFORM = "wayland";
      XMODIFIERS = "@im=fcitx";
      QT_IM_MODULE = "fcitx";
      # GTK_IM_MODULE = "wayland";
    };

    home.packages = with pkgs; [
      glib
    ];

    modules.packages.rime.extraFiles = lib.mkBefore [
      {
        name = "fcitx5.custom.yaml";
        data = ''
          patch:
            "menu/page_size": 9
            "style/candidate_list_layout": linear
            "style/translucency": true

            schema_list:
              - schema: rime_mint # 薄荷拼音
              - schema: rime_mint_flypy # 薄荷拼音-小鹤混输方案

            # dbus-send --print-reply=literal --dest=org.fcitx.Fcitx5 /controller org.fcitx.Fcitx.Controller1.DebugInfo
            # 特定App默认中/英文输入
            "app_options/org.wezfurlong.wezterm":
              ascii_mode: true
              ascii_punct: true
            "app_options/kitty":
              ascii_mode: true
              ascii_punct: true
            "app_options/code": # Visual Studio Code
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
            ${lib.optionalString (cfgDesktop.kde.enable) ''
              "app_options/org.kde.krunner.desktop":
                  ascii_mode: true
                  ascii_punct: true
              "app_options/org.kde.plasmashell":
                  ascii_mode: true
                  ascii_punct: true
            ''}
        '';
      }
    ];
    xdg.dataFile = {
      "fcitx5/themes" = {
        source = "${fictx5-themes}/share/fcitx5/themes";
        recursive = true;
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
          MenuFont="inter 11"
          TrayFont="Maple Mono NF 11"
          TrayOutlineColor=#000000
          TrayTextColor=#ffffff
          PreferTextIcon=True
          ShowLayoutNameInIcon=True
          UseInputMethodLangaugeToDisplayText=True
          Theme=macOS-light
          DarkTheme=macOS-dark
          UseDarkTheme=True
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
  };
}
