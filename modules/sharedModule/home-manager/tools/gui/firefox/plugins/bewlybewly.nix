{
  pkgs,
  lib,
  myvars,
  ...
}:
{
  programs = {
    firefox = {
      profiles = {
        "${myvars.username}" = {
          extensions = {
            settings = {
              "addon@bewlybewly.com".settings = {
                force = true;
                webext-demo = "Storage Demo";
                accessKey = "";
                settings = ''
                  {
                    "touchScreenOptimization": false,
                    "enableGridLayoutSwitcher": true,
                    "enableHorizontalScrolling": false,
                    "language": "cmn-CN",
                    "customizeFont": "recommend",
                    "fontFamily": "CJKEmDash, Numbers, Onest, ShangguSansSCVF, -apple-system, BlinkMacSystemFont, InterVariable, Inter, \"Segoe UI\", Cantarell, \"Noto Sans\", \"Roboto Flex\", Roboto, sans-serif, ui-sans-serif, system-ui, \"Apple Color Emoji\", \"Twemoji Mozilla\", \"Noto Color Emoji\", \"Segoe UI Emoji\", \"Segoe UI Symbol\", emoji",
                    "overrideDanmakuFont": true,
                    "removeTheIndentFromChinesePunctuation": false,
                    "disableFrostedGlass": false,
                    "reduceFrostedGlassBlur": false,
                    "disableShadow": false,
                    "videoCardLinkOpenMode": "newTab",
                    "topBarLinkOpenMode": "currentTabIfNotHomepage",
                    "searchBarLinkOpenMode": "currentTabIfNotHomepage",
                    "closeDrawerWithoutPressingEscAgain": false,
                    "blockAds": true,
                    "blockTopSearchPageAds": true,
                    "enableVideoPreview": true,
                    "enableVideoCtrlBarOnVideoCard": true,
                    "hoverVideoCardDelayed": true,
                    "useOldTopBar": false,
                    "autoHideTopBar": false,
                    "showTopBarThemeColorGradient": true,
                    "showBewlyOrBiliTopBarSwitcher": true,
                    "showBewlyOrBiliPageSwitcher": true,
                    "topBarIconBadges": "number",
                    "openNotificationsPageAsDrawer": true,
                    "alwaysUseDock": false,
                    "autoHideDock": false,
                    "halfHideDock": false,
                    "dockPosition": "right",
                    "dockItemVisibilityList": [],
                    "dockItemsConfig": [
                        {
                            "page": "Home",
                            "visible": true,
                            "openInNewTab": false,
                            "useOriginalBiliPage": false
                        },
                        {
                            "page": "Search",
                            "visible": true,
                            "openInNewTab": false,
                            "useOriginalBiliPage": false
                        },
                        {
                            "page": "Anime",
                            "visible": true,
                            "openInNewTab": false,
                            "useOriginalBiliPage": false
                        },
                        {
                            "page": "Favorites",
                            "visible": true,
                            "openInNewTab": false,
                            "useOriginalBiliPage": false
                        },
                        {
                            "page": "History",
                            "visible": true,
                            "openInNewTab": false,
                            "useOriginalBiliPage": false
                        },
                        {
                            "page": "WatchLater",
                            "visible": true,
                            "openInNewTab": false,
                            "useOriginalBiliPage": false
                        },
                        {
                            "page": "Moments",
                            "visible": true,
                            "openInNewTab": false,
                            "useOriginalBiliPage": true
                        }
                    ],
                    "disableDockGlowingEffect": false,
                    "disableLightDarkModeSwitcherOnDock": false,
                    "backToTopAndRefreshButtonsAreSeparated": true,
                    "sidebarPosition": "right",
                    "autoHideSidebar": false,
                    "theme": "auto",
                    "themeColor": "#00a1d6",
                    "useLinearGradientThemeColorBackground": false,
                    "wallpaperMode": "buildIn",
                    "wallpaper": "https://cdn.jsdelivr.net/gh/BewlyBewly/Imgs/wallpapers/rocky-mountain-cloudscape.jpg",
                    "enableWallpaperMasking": true,
                    "wallpaperMaskOpacity": 80,
                    "wallpaperBlurIntensity": 0,
                    "locallyUploadedWallpaper": null,
                    "customizeCSS": false,
                    "customizeCSSContent": "",
                    "searchPageDarkenOnSearchFocus": true,
                    "searchPageBlurredOnSearchFocus": false,
                    "searchPageLogoColor": "themeColor",
                    "searchPageLogoGlow": true,
                    "searchPageShowLogo": true,
                    "searchPageSearchBarFocusCharacter": "",
                    "individuallySetSearchPageWallpaper": false,
                    "searchPageWallpaperMode": "buildIn",
                    "searchPageWallpaper": "",
                    "searchPageEnableWallpaperMasking": false,
                    "searchPageWallpaperMaskOpacity": 0,
                    "searchPageWallpaperBlurIntensity": 0,
                    "recommendationMode": "web",
                    "disableFilterForFollowedUser": false,
                    "filterOutVerticalVideos": false,
                    "enableFilterByViewCount": false,
                    "filterByViewCount": 10000,
                    "enableFilterByDuration": false,
                    "filterByDuration": 3600,
                    "enableFilterByTitle": false,
                    "filterByTitle": [],
                    "enableFilterByUser": false,
                    "filterByUser": [],
                    "followingTabShowLivestreamingVideos": true,
                    "homePageTabVisibilityList": [
                        {
                            "page": "ForYou",
                            "visible": true
                        },
                        {
                            "page": "Following",
                            "visible": true
                        },
                        {
                            "page": "SubscribedSeries",
                            "visible": true
                        },
                        {
                            "page": "Trending",
                            "visible": true
                        },
                        {
                            "page": "Ranking",
                            "visible": true
                        },
                        {
                            "page": "Live",
                            "visible": true
                        }
                    ],
                    "alwaysShowTabsOnHomePage": false,
                    "useSearchPageModeOnHomePage": true,
                    "searchPageModeWallpaperFixed": false,
                    "adaptToOtherPageStyles": true,
                    "showTopBar": true,
                    "useOriginalBilibiliTopBar": false,
                    "useOriginalBilibiliHomepage": false
                    }
                '';
                gridLayout = builtins.fromJSON ''
                  {"home":"adaptive"}
                '';
                sidePanel = builtins.fromJSON ''
                  {"home":true}
                '';
              };
            };
            packages = with pkgs.nur.repos.rycee.firefox-addons; [
              (pkgs.nur.repos.rycee.firefox-addons.buildFirefoxXpiAddon rec {
                pname = "bewlybewly";
                version = "0.41.1";
                addonId = "addon@bewlybewly.com";
                url = "https://addons.mozilla.org/firefox/downloads/file/4444302/bewlybewly-${version}.xpi";
                sha256 = "sha256-mzKbUflAhY5uHVe0cTonqZ0rqQhHsAiX/JSveXHkVho=";
                meta = with lib; {
                  homepage = "https://github.com/bewlybewly/bewlybewly";
                  description = "bewlybewly is a browser extension for bilibili that aims to enhance the user experience by redesigning the bilibili ui. the design is inspired by youtube, vision os, and ios, resulting in a more visually appealing and user-friendly interface.source code: https://github.com/hakadao/bewlybewly";
                  license = licenses.mit;
                  mozpermissions = [
                    "activetab"
                    "<all_urls>"
                    "storage"
                    "declarativenetrequest"
                    "tabs"
                    "webrequest"
                    "webrequestblocking"
                    "cookies"
                    "*://bilibili.com"
                    "*://hdslb.com"
                    "*://www.bilibili.com"
                    "*://search.bilibili.com"
                    "*://t.bilibili.com"
                    "*://space.bilibili.com"
                    "*://message.bilibili.com"
                    "*://member.bilibili.com"
                    "*://account.bilibili.com"
                    "*://www.hdslb.com"
                    "*://passport.bilibili.com"
                    "*://music.bilibili.com"
                  ];
                  platforms = platforms.all;
                };
              })
            ];
          };
        };
      };
    };
  };
}
