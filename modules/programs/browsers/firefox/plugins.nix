{
  flake.modules.homeManager.programs =
    {
      pkgs,
      username,
      ...
    }:
    let
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

      # nopecha-plugin = rycee-addons.buildFirefoxXpiAddon rec {
      #   pname = "NopeCHA: CAPTCHA Solver";
      #   version = "0.4.13";
      #   addonId = "{2f67aecb-5dac-4f76-9378-0ac4f2bedc9c}";
      #   url = "https://addons.mozilla.org/firefox/downloads/file/4393222/noptcha-${version}.xpi";
      #   sha256 = "sha256-HvH8p8dcxIcUaASav/HM7YblD3dHJxCWRbXWDywBP6M=";
      #   meta.homepage = "https://nopecha.com";
      # };

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

      programs.firefox.profiles."${username}" = {
        extensions = {
          force = true;
          packages = [
            bewlybewly-plugin
            rycee-addons.enhanced-github
            fehelper-plugin
            rycee-addons.imagus
            # rycee-addons.immersive-translate
            # nopecha-plugin
            rycee-addons.tampermonkey
            rycee-addons.ublock-origin
            # rycee-addons.vimium
            rycee-addons.tridactyl
            # rycee-addons.xbrowsersync
            rycee-addons.duckduckgo-privacy-essentials
          ];

          settings = {
            "tridactyl.vim@cmcaine.co.uk".permissions = [
              "activeTab"
              "bookmarks"
              "browsingData"
              "contextMenus"
              "contextualIdentities"
              "cookies"
              "clipboardWrite"
              "clipboardRead"
              "downloads"
              "find"
              "history"
              "search"
              "sessions"
              "storage"
              "tabHide"
              "tabs"
              "topSites"
              "management"
              "nativeMessaging"
              "webNavigation"
              "webRequest"
              "webRequestBlocking"
              "proxy"
              "<all_urls>"
            ];
            #vim
            # "{d7742d87-e61d-4b78-b8a1-b469842139fa}".permissions = [
            #   "tabs"
            #   "bookmarks"
            #   "history"
            #   "storage"
            #   "sessions"
            #   "notifications"
            #   "scripting"
            #   "favicon"
            #   "webNavigation"
            #   "search"
            #   "clipboardRead"
            #   "clipboardWrite"
            #   "<all_urls>"
            #   "file:///"
            #   "file:///*/"
            # ];
            "addon@bewlybewly.com" = {
              force = true;
              # permissions = [
              #   "storage"
              #   "declarativeNetRequest"
              #   "tabs"
              #   "webRequest"
              #   "webRequestBlocking"
              #   "cookies"
              # ];
              settings = bewlybewlySettings;
            };
            "firefox@fehelper.com" = {
              force = true;
            };
            "uBlock0@raymondhill.net" = {
              permissions = [
                "alarms"
                "dns"
                "menus"
                "privacy"
                "storage"
                "tabs"
                "unlimitedStorage"
                "webNavigation"
                "webRequest"
                "webRequestBlocking"
                "<all_urls>"
                "http://*/*"
                "https://*/*"
                "file://*/*"
                "https://easylist.to/*"
                "https://*.fanboy.co.nz/*"
                "https://filterlists.com/*"
                "https://forums.lanik.us/*"
                "https://github.com/*"
                "https://*.github.io/*"
                "https://github.com/uBlockOrigin/*"
                "https://ublockorigin.github.io/*"
                "https://*.reddit.com/r/uBlockOrigin/*"
              ];
              settings = {
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
            "jid1-ZAdIEUB7XOzOJw@jetpack" = {
              permissions = [
                "contextMenus"
                "webRequest"
                "webRequestBlocking"
                "*://*/*"
                "webNavigation"
                "activeTab"
                "tabs"
                "storage"
                "<all_urls>"
                "alarms"
              ];
              settings = {
                httpsEverywhereEnabled = true;
                embeddedTweetsEnabled = true;
                GPC = true;
                youtubePreviewsEnabled = true;
              };
            };
          };
        };
      };

    };
}
