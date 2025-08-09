{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules'.packages;

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
      default = true;
      description = "Whether to enable translate.";
    };
  };

  config = lib.mkIf cfg.translate.enable {
    home.packages = with pkgs; [
      pot
      grimblast
      tesseract
    ];

    systemd.user.services.pot = {
      Unit = {
        Description = "Pot translation daemon";
        After = [ "network.target" ];
      };
      Service = {
        ExecStart = "${lib.getExe pkgs.pot}";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    xdg.configFile = {
      "autostart/pot-app.desktop" = {
        enable = false;
        text = ''
          [Desktop Entry]
          Type=Application
          Version=1.0
          Name=pot
          Comment=potstartup script
          Exec=${pkgs.pot}/bin/pot
          StartupNotify=false
          Terminal=false
        '';
      };
      "com.pot-app.desktop/plugins/recognize/plugin.com.pot-app.rapid" = {
        enable = false;
        executable = true;
        source = "${rapid}/share/pot/plugins/rapid";
      };
      "com.pot-app.desktop/config.json" = {
        enable = false;
        text = ''
          {
              "check_update": true,
              "plugin.com.pot-app.rapid@apm65hrx1p": {},
              "lingva": {
                  "enable": false
              },
              "app_language": "zh_cn",
              "hotkey_selection_translate": "",
              "collection_service_list": [],
              "hotkey_ocr_translate": "Alt+S",
              "proxy_port": "",
              "translate_window_position": "mouse",
              "app_fallback_font": "default",
              "recognize_window_width": 800,
              "recognize_hide_window": false,
              "tts_service_list": [
                  "lingva_tts"
              ],
              "bing": {},
              "app_font_size": 16,
              "recognize_delete_newline": false,
              "recognize_window_height": 400,
              "hide_source": false,
              "incremental_translate": false,
              "hotkey_input_translate": "Alt+A",
              "recognize_service_list": [
                  "plugin.com.pot-app.rapid@26e54uzymfu"
              ],
              "webdav_username": "",
              "proxy_host": "",
              "dev_mode": false,
              "recognize_auto_copy": false,
              "translate_target_language": "zh_cn",
              "app_theme": "system",
              "dynamic_translate": false,
              "translate_auto_copy": "disable",
              "translate_detect_engine": "baidu",
              "google": {
                  "enable": false
              },
              "clipboard_monitor": false,
              "translate_always_on_top": false,
              "recognize_close_on_blur": true,
              "transparent": true,
              "proxy_password": "",
              "yandex": {
                  "enable": false
              },
              "hotkey_ocr_recognize": "Alt+D",
              "translate_second_language": "en",
              "translate_window_height": 420,
              "translate_hide_window": false,
              "translate_remember_window_size": false,
              "aliyun_access_token": "",
              "plugin.com.pot-app.rapid@26e54uzymfu": {},
              "proxy_username": "",
              "webdav_url": "",
              "lingva_tts": {},
              "webdav_password": "",
              "translate_source_language": "auto",
              "ecdict": {
                  "enable": false
              },
              "no_proxy": "localhost,127.0.0.1",
              "translate_close_on_blur": true,
              "history_disable": false,
              "translate_delete_newline": false,
              "server_port": 60828,
              "app_font": "default",
              "translate_remember_language": false,
              "translate_window_width": 350,
              "hide_language": false,
              "proxy_enable": false,
              "recognize_language": "auto",
              "backup_type": "webdav",
              "tray_click_event": "config",
              "translate_service_list": [
                  "bing",
                  "lingva",
                  "yandex",
                  "google",
                  "ecdict"
              ]
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
