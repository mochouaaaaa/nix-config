{
  pkgs,
  lib,
  username,
  ...
}:
{
  programs = {
    firefox = {
      profiles = {
        "${username}" = {
          extensions = {
            packages = with pkgs.nur.repos.rycee.firefox-addons; [
              (pkgs.nur.repos.rycee.firefox-addons.buildFirefoxXpiAddon rec {
                pname = "FeHelper(前端助手)";
                version = "2025.6.2820";
                addonId = "firefox@fehelper.com";
                url = "https://addons.mozilla.org/firefox/downloads/file/4524846/fehelper-${version}.xpi";
                sha256 = "sha256-/LpMm1BWWxJdkd9FLfO0spOB1fCxa/sfU6O2TRJFBRg=";
                meta = with lib; {
                  homepage = "https://www.fehelper.com";
                  description = "FeHelper是一个功能强大的 开源浏览器扩展，专为前端开发者和各类职场人设计，集成了30+种实用工具，包括JSON处理、代码美化、接口调试、AI助手、图像处理等核心功能，支持Chrome、Edge、Firefox浏览器。";
                  license = licenses.mit;
                  mozpermissions = [
                    "tabs"
                    "scripting"
                    "contextMenus"
                    "activeTab"
                    "storage"
                    "notifications"
                    "unlimitedStorage"
                    "*://*/*"
                    "*://*/*"
                    "file://*/*"
                  ];
                  platforms = platforms.all;
                };
              })
            ];

            settings = {
              "firefox@fehelper.com".settings = {
                force = true;
                "FH_USER_ID" = "fh_1751549186346_7g9xhw8hs";
                "FH_LAST_ACTIVE_DATE" = "2025-07-03";
                "FH_USER_USAGE_DATA" = ''
                  {
                      "dailyUsage": {
                          "2025-07-03": {
                              "date": "2025-07-03",
                              "tools": {
                                  "options": 1,
                                  "json-format": 1
                              }
                          }
                      },
                      "tools": {
                          "options": 1,
                          "json-format": 1
                      }
                  }
                '';
                "fehelper_latest_version_data" = {
                  "timestamp" = 1751549186685;
                  "currentVersion" = "2025.6.2820";
                  "latestVersion" = "2025.6.2820";
                  "needUpdate" = false;
                };
                "DYNAMIC_TOOL:json-diff" = 1751550215197;
                "DYNAMIC_TOOL:regexp" = 1751550236098;
                "DYNAMIC_TOOL:trans-radix" = 1751550238728;
                "DYNAMIC_TOOL:en-decode" = 1751550241296;
                "DYNAMIC_TOOL:timestamp" = 1751550244388;
                "DYNAMIC_TOOL:image-base64" = 1751550259660;
              };
            };
          };
        };
      };
    };
  };
}
