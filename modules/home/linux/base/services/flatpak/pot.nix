{
  lib,
  config,
  pkgs,
  pkgs-stable,
  ...
}:
let
  cfg = config.modules'.packages;

  pot = pkgs-stable.pot;

  rapid = pkgs.stdenv.mkDerivation rec {
    pname = "pot-rapid-plugin";
    version = "2.0.2";

    src = pkgs.fetchzip {
      url = "https://github.com/pot-app/pot-app-recognize-plugin-rapid/releases/download/${version}/x86_64-unknown-linux-gnu.zip";
      sha256 = "sha256-+7jtjyBrKg8xtidBGS7ur1qDr3knDPIEPts6pMZzOcY=";
    };

    nativeBuildInputs = [ pkgs.unzip ];

    installPhase = ''
      unzip plugin.com.pot-app.rapid.potext
      rm plugin.com.pot-app.rapid.potext

      mkdir -p $out/share/pot/plugins/rapid
      # cp -rv . $out/share/pot/plugins/rapid/
      install -m775 . $out/share/pot/plugins/rapid
    '';
  };

in
{
  options.modules'.packages = {
    translate.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable translate.";
    };
  };

  config = lib.mkIf (cfg.translate.enable && config.programs.desktop.enable) {
    home.packages = with pkgs; [
      pot
      grimblast
      tesseract
    ];

    # services.flatpak.packages = [
    #   "com.pot_app.pot"
    # ];

    systemd.user.services.pot = {
      Unit = {
        Description = "Pot translation daemon";
        After = [ "graphical-session-pre.target" ];
      };
      Service = {
        ExecStart = "${lib.getExe pot}";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    home.file = {
      # "com.pot-app.desktop/plugins/recognize/plugin.com.pot-app.rapid" = {
      #   enable = false;
      #   executable = true;
      #   source = "${rapid}/share/pot/plugins/rapid";
      # };
      ".var/app/com.pot_app.pot/config/com.pot-app.desktop/config.json" = {
        enable = false;
        text = ''
          {
            "webdav_password": "",
            "recognize_close_on_blur": false,
            "tesseract": {},
            "translate_window_position": "mouse",
            "translate_window_height": 420,
            "translate_service_list": [
              "deepl",
              "bing",
              "lingva",
              "yandex",
              "google",
              "ecdict"
            ],
            "translate_source_language": "auto",
            "recognize_auto_copy": false,
            "translate_detect_engine": "tencent",
            "server_port": 60827,
            "backup_type": "webdav",
            "check_update": true,
            "app_font_size": 16,
            "hide_source": false,
            "recognize_service_list": ["tesseract", "system"],
            "webdav_username": "",
            "proxy_username": "",
            "proxy_password": "",
            "deepl": {},
            "hotkey_selection_translate": "",
            "translate_close_on_blur": true,
            "dev_mode": false,
            "tray_click_event": "config",
            "hotkey_ocr_translate": "",
            "aliyun_access_token": "",
            "translate_hide_window": false,
            "app_fallback_font": "default",
            "proxy_host": "127.0.0.1",
            "recognize_delete_newline": false,
            "clipboard_monitor": false,
            "translate_always_on_top": true,
            "hide_language": false,
            "tts_service_list": ["lingva_tts"],
            "incremental_translate": false,
            "translate_target_language": "zh_cn",
            "collection_service_list": [],
            "system": {},
            "lingva_tts": {},
            "history_disable": false,
            "translate_second_language": "en",
            "lingva": {},
            "recognize_language": "auto",
            "translate_remember_language": false,
            "proxy_enable": false,
            "transparent": true,
            "translate_window_width": 350,
            "bing": {},
            "ecdict": {},
            "google": {},
            "translate_delete_newline": false,
            "webdav_url": "",
            "hotkey_input_translate": "",
            "proxy_port": 7890,
            "app_theme": "system",
            "translate_remember_window_size": false,
            "hotkey_ocr_recognize": "",
            "app_font": "default",
            "app_language": "zh_cn",
            "recognize_hide_window": false,
            "yandex": {},
            "dynamic_translate": false,
            "translate_auto_copy": "disable",
            "no_proxy": "localhost"
          }
        '';
      };
    };

    modules'.shortcuts.global = [
      {
        "ALT-a" = {
          launch = [
            "curl"
            "127.0.0.1:60828/input_translate"
          ];
        };
        "ALT-d" = {
          launch = [
            "curl"
            "127.0.0.1:60828/selection_translate"
          ];
        };
        "ALT-s" = {
          launch = [
            "bash"
            "-c"
            ''
              rm -f ~/.cache/com.pot-app.desktop/pot_screenshot_cut.png
              mkdir -p ~/.cache/com.pot-app.desktop
              if grimblast --freeze save area ~/.cache/com.pot-app.desktop/pot_screenshot_cut.png; then
                  curl "127.0.0.1:60828/ocr_translate?screenshot=false"
              fi
            ''
          ];
        };
      }
    ];
  };
}
