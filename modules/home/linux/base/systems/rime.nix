{
  lib,
  pkgs,
  config,
  ...
}:
let

  rime-data = config.modules'.packages.rime.data-package;

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
  config = lib.mkIf (config.programs.desktop.enable) {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        fcitx5-with-addons = pkgs.kdePackages.fcitx5-with-addons;
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
          librime-octagram
        ];
        waylandFrontend = true;
      };
    };

    home.sessionVariables = {
      QT_QPA_PLATFORM = "wayland";
      XMODIFIERS = "@im=fcitx";
      QT_IM_MODULE = "fcitx";
    };

    modules'.packages.rime.fcitx5CustomYaml =
      let
        ascii = {
          ascii_mode = true;
          ascii_punct = true;
        };
      in
      {
        # dbus-send --print-reply=literal --dest=org.fcitx.Fcitx5 /controller org.fcitx.Fcitx.Controller1.DebugInfo
        patch = {
          "menu/page_size" = 9;
          "style/candidate_list_layout" = "linear";
          "style/translucency" = true;

          schema_list = [
            { schema = "rime_mint"; }
            { schema = "rime_mint_flypy"; }
          ];

          "app_options/gcr-prompter" = ascii;
          "app_options/org.wezfurlong.wezterm" = ascii;
          "app_options/kitty" = ascii;
          "app_options/foot" = ascii;
          "app_options/code" = ascii;
          "app_options/neovide" = ascii;
          "app_options/firefox" = ascii;
          "app_options/.vicinae-wrapped" = ascii;
          "app_options/intellij-wrapped" = ascii;
          "app_options/jetbrains-intellij" = ascii;
          "app_options/pycharm-wrapped" = ascii;
          "app_options/jetbrains-pycharm" = ascii;
          "app_options/goland-wrapped" = ascii;
          "app_options/jetbrains-goland" = ascii;
          "app_options/webstorm-wrapped" = ascii;
          "app_options/datagrip-wrapped" = ascii;
          "app_options/jetbrains-datagrip" = ascii;
          "app_options/.albert-wrapped" = ascii;
        };
      };

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
          Name=Other
          Default Layout=us
          DefaultIM=rime

          [Groups/0/Items/0]
          Name=rime
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
