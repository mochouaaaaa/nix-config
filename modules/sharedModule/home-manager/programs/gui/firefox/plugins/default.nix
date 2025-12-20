{
  lib,
  pkgs,
  config,
  username,
  ...
}:
let
  cfg = config.modules'.packages.firefox.plugins;
  rycee-addons = pkgs.nur.repos.rycee.firefox-addons;

  # --- Custom Plugin Derivations ---
  bewlybewly-plugin = rycee-addons.buildFirefoxXpiAddon rec {
    pname = "bewlybewly";
    version = "0.41.1";
    addonId = "addon@bewlybewly.com";
    url = "https://addons.mozilla.org/firefox/downloads/file/4444302/bewlybewly-${version}.xpi";
    sha256 = "sha256-mzKbUflAhY5uHVe0cTonqZ0rqQhHsAiX/JSveXHkVho=";
    meta.homepage = "https://github.com/bewlybewly/bewlybewly";
  };

  fehelper-plugin = rycee-addons.buildFirefoxXpiAddon rec {
    pname = "FeHelper(前端助手)";
    version = "2025.6.2820";
    addonId = "firefox@fehelper.com";
    url = "https://addons.mozilla.org/firefox/downloads/file/4524846/fehelper-${version}.xpi";
    sha256 = "sha256-/LpMm1BWWxJdkd9FLfO0spOB1fCxa/sfU6O2TRJFBRg=";
    meta.homepage = "https://www.fehelper.com";
  };

  nopecha-plugin = rycee-addons.buildFirefoxXpiAddon rec {
    pname = "NopeCHA: CAPTCHA Solver";
    version = "0.4.13";
    addonId = "{2f67aecb-5dac-4f76-9378-0ac4f2bedc9c}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4393222/noptcha-${version}.xpi";
    sha256 = "sha256-HvH8p8dcxIcUaASav/HM7YblD3dHJxCWRbXWDywBP6M=";
    meta.homepage = "https://nopecha.com";
  };

  # Nix attribute set for BewlyBewly settings for improved readability
  bewlybewlySettings = {
    touchScreenOptimization = false;
    enableGridLayoutSwitcher = true;
    language = "cmn-CN";
    customizeFont = "recommend";
    fontFamily = "CJKEmDash, Numbers, Onest, ShangguSansSCVF, -apple-system, BlinkMacSystemFont, InterVariable, Inter, \"Segoe UI\", Cantarell, \"Noto Sans\", \"Roboto Flex\", Roboto, sans-serif, ui-sans-serif, system-ui, \"Apple Color Emoji\", \"Twemoji Mozilla\", \"Noto Color Emoji\", \"Segoe UI Emoji\", \"Segoe UI Symbol\", emoji";
    overrideDanmakuFont = true;
    videoCardLinkOpenMode = "newTab";
    topBarLinkOpenMode = "currentTabIfNotHomepage";
    searchBarLinkOpenMode = "currentTabIfNotHomepage";
    blockAds = true;
    useOldTopBar = false;
    autoHideTopBar = false;
    dockPosition = "right";
    theme = "auto";
    themeColor = "#00a1d6";
    wallpaperMode = "buildIn";
    wallpaper = "https://cdn.jsdelivr.net/gh/BewlyBewly/Imgs/wallpapers/rocky-mountain-cloudscape.jpg";
    enableWallpaperMasking = true;
    wallpaperMaskOpacity = 80;
    recommendationMode = "web";
    useSearchPageModeOnHomePage = true;
  };
in
{
  # --- Plugin Options ---
  options.modules'.packages.firefox.plugins = with lib; {
    bewlybewly = mkEnableOption "BewlyBewly";
    bitwarden = mkEnableOption "Bitwarden";
    enhanced-github = mkEnableOption "Enhanced GitHub";
    fehelper = mkEnableOption "FeHelper";
    imagus = mkEnableOption "Imagus";
    immersive-translate = mkEnableOption "Immersive Translate";
    nope-cha = mkEnableOption "NopeCHA";
    tampermonkey = mkEnableOption "Tampermonkey";
    ublock-origin = mkEnableOption "uBlock Origin";
    vimium = mkEnableOption "Vimium";
    xbrowsersync = mkEnableOption "xBrowserSync";
  };

  # --- Plugin Configuration ---
  config = {
    programs.firefox.profiles."${username}".extensions = lib.mkMerge [
      {
        force = true;
      }
      # Each plugin is defined in its own conditional block.
      # `mkMerge` will concatenate the `packages` lists and recursively merge the `settings` attrs.
      (lib.mkIf cfg.bewlybewly {
        packages = [ bewlybewly-plugin ];
        settings = {
          "addon@bewlybewly.com".settings = {
            force = true;
            settings = builtins.toJSON bewlybewlySettings;
          };
        };
      })

      (lib.mkIf cfg.bitwarden {
        packages = [ rycee-addons.bitwarden ];
      })

      (lib.mkIf cfg."enhanced-github" {
        packages = [ rycee-addons.enhanced-github ];
      })

      (lib.mkIf cfg.fehelper {
        packages = [ fehelper-plugin ];
        settings = {
          "firefox@fehelper.com".settings = {
            force = true;
            "FH_USER_ID" = "fh_1751549186346_7g9xhw8hs";
            "FH_LAST_ACTIVE_DATE" = "2025-07-03";
          };
        };
      })

      (lib.mkIf cfg.imagus {
        packages = [ rycee-addons.imagus ];
      })

      (lib.mkIf cfg."immersive-translate" {
        packages = [ rycee-addons.immersive-translate ];
      })

      (lib.mkIf cfg."nope-cha" {
        packages = [ nopecha-plugin ];
      })

      (lib.mkIf cfg.tampermonkey {
        packages = [ rycee-addons.tampermonkey ];
      })

      (lib.mkIf cfg."ublock-origin" {
        packages = [ rycee-addons.ublock-origin ];
        settings = {
          "uBlock0@raymondhill.net".settings = {
            force = true;
            selectedFilterLists = [
              "ublock-filters"
              "ublock-badware"
              "ublock-privacy"
              "ublock-quick-fixes"
              "ublock-unbreak"
              "easylist"
              "easyprivacy"
              "urlhaus-1"
              "fanboy-cookiemonster"
              "ublock-cookies-easylist"
              "adguard-cookies"
              "ublock-cookies-adguard"
              "fanboy-social"
              "adguard-social"
            ];
          };
        };
      })

      (lib.mkIf cfg.vimium {
        packages = [ rycee-addons.vimium ];
      })

      (lib.mkIf cfg.xbrowsersync {
        packages = [ rycee-addons.xbrowsersync ];
      })
    ];
  };
}
