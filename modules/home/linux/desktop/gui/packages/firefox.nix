{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfg = config.modules'.packages.firefox;

  themes = pkgs.stdenv.mkDerivation {
    name = "firefox-themes";
    src = pkgs.fetchFromGitHub {
      owner = "vinceliuice";
      repo = "WhiteSur-firefox-theme";
      tag = "2025-07-28";
      hash = "sha256-T1gWHKc6W9Z+PjuLo8wq145/ZGXM5L2RekXeEyoo0Ls=";
    };

    left_button = "4";
    right_button = "3";
    adaptive = "-adaptive";

    installPhase = ''
      TARGET="$out/share/mozilla/firefox/firefox-themes"
      mkdir -p "$TARGET/Monterey/parts"

      cp -rf src/Monterey/* "$TARGET/Monterey/" 2>/dev/null || true
      cp -f src/customChrome.css "$TARGET/customChrome.css"

      cp -rf src/common/icons "$TARGET/Monterey/"
      cp -rf src/common/titlebuttons "$TARGET/Monterey/"
      cp -rf src/common/pages "$TARGET/Monterey/"
      cp -f src/common/*.css "$TARGET/Monterey/"
      cp -rf src/common/parts/*.css "$TARGET/Monterey/parts/"

      cp -f "src/userChrome-Monterey-alt$adaptive.css" "$TARGET/userChrome.css"
      cp -f "src/userContent-Monterey$adaptive.css" "$TARGET/userContent.css"

      cp -f "src/WhiteSur/parts/headerbar-urlbar.css" "$TARGET/Monterey/parts/headerbar-urlbar-alt.css"

      substituteInPlace "$TARGET/userChrome.css" \
        --replace "left_header_button_3" "left_header_button_$left_button" \
        --replace "right_header_button_3" "right_header_button_$right_button"

    '';
  };

in
{

  config = lib.mkIf (cfg.enable && config.programs.desktop.enable) {

    home.file = {
      ".mozilla/firefox/${username}/chrome/Monterey".source =
        "${themes}/share/mozilla/firefox/firefox-themes/Monterey";
    };

    programs.firefox.profiles.${username} = {
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        adaptive-tab-bar-colour
      ];
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.uidensity" = 0;
        "layers.acceleration.force-enabled" = true;
        "mozilla.widget.use-argb-visuals" = true;
        "widget.gtk.rounded-bottom-corners.enabled" = true;
        "widget.gtk.non-native-titlebar-buttons.enabled" = false;
        "svg.context-properties.content.enabled" = true;
      };
      userChrome = ''
        @import "Monterey/theme-alt-adaptive.css";
        @import "Monterey/hide-single-tab.css";
        @import "customChrome.css";
      '';
      userContent = ''
        @import "Monterey/colors/light-adaptive.css";
        @import "Monterey/colors/dark-adaptive.css";

        @import "Monterey/pages/newtab-adaptive.css";
      '';
    };

    home.file.".mozilla/firefox/${username}/chrome/customChrome.css".text = ''
      #tabbrowser-tabbox {
        box-shadow: none !important;
      }

      #navigator-toolbox,
      #TabsToolbar,
      #nav-bar,
      #PersonalToolbar,
      #sidebar-box,
      .tab-background,
      .urlbar-background,
      findbar {
        transition:
          background-color 0.5s cubic-bezier(0, 0, 0, 1),
          border-color 0.5s cubic-bezier(0, 0, 0, 1) !important;
      }

      .Sidebar,
      .bottom-space {
        transition: background-color 0.5s cubic-bezier(0, 0, 0, 1) !important;
      }
    '';

    xdg.mimeApps =
      let
        associations = builtins.listToAttrs (
          map
            (name: {
              inherit name;
              value =
                let
                  zen-browser = config.programs.zen-browser.package;
                in
                zen-browser.meta.desktopFileName;
            })
            [
              "application/x-extension-shtml"
              "application/x-extension-xhtml"
              "application/x-extension-html"
              "application/x-extension-xht"
              "application/x-extension-htm"
              "x-scheme-handler/unknown"
              "x-scheme-handler/mailto"
              "x-scheme-handler/chrome"
              "x-scheme-handler/about"
              "x-scheme-handler/https"
              "x-scheme-handler/http"
              "application/xhtml+xml"
              "application/json"
              "text/plain"
              "text/html"
            ]
        );
      in
      {
        associations.added = associations;
        defaultApplications =
          let
            browser = [ "firefox.desktop" ];
          in
          {
            "application/json" = browser;
            "application/pdf" = browser; # TODO: pdf viewer
            "text/html" = browser;
            "text/xml" = browser;
            "application/xml" = browser;
            "application/xhtml+xml" = browser;
            "application/xhtml_xml" = browser;
            "application/rdf+xml" = browser;
            "application/rss+xml" = browser;
            "application/x-extension-htm" = browser;
            "application/x-extension-html" = browser;
            "application/x-extension-shtml" = browser;
            "application/x-extension-xht" = browser;
            "application/x-extension-xhtml" = browser;
            # define default applications for some url schemes.
            "x-scheme-handler/about" = browser; # open `about:` url with `browser`
            "x-scheme-handler/ftp" = browser; # open `ftp:` url with `browser`
            "x-scheme-handler/http" = browser;
            "x-scheme-handler/https" = browser;
          };
      };
  };
}
