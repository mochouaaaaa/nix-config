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
      tag = "2025-02-12";
      hash = "sha256-aoUO+W2CMZ/d0TRoZv/4CPM2yrDGaVQ/1Q9BA0aHjOk=";
    };

    installPhase = ''
      mkdir -p $out/share/mozilla/firefox/firefox-themes

      cp -rf ./src/Monterey $out/share/mozilla/firefox/firefox-themes/
      cp -rf ./src/common/* $out/share/mozilla/firefox/firefox-themes/Monterey/

      cp -rf ./src/customChrome.css $out/share/mozilla/firefox/firefox-themes/customChrome.css
      cp -rf ./src/userChrome-Monterey.css $out/share/mozilla/firefox/firefox-themes/userChrome.css
      cp -rf ./src/userContent-Monterey.css $out/share/mozilla/firefox/firefox-themes/userContent.css
      cp -rf ./src/userChrome-Monterey-alt.css $out/share/mozilla/firefox/firefox-themes/userChrome.css
      cp -rf ./src/WhiteSur/parts/headerbar-urlbar.css $out/share/mozilla/firefox/firefox-themes/Monterey/parts/headerbar-urlbar-alt.css
    '';
  };

in
{

  config = lib.mkIf (cfg.enable && config.programs.desktop.enable) {

    home.file = {
      ".mozilla/firefox/${username}/chrome".source = "${themes}/share/mozilla/firefox/firefox-themes";
    };

    programs.firefox = {
      profiles = {
        "${username}" = {
          settings = {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          };
        };
      };
    };

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
            # "application/json" = browser;
            # "application/pdf" = browser; # TODO: pdf viewer
            # "text/html" = browser;
            # "text/xml" = browser;
            # "application/xml" = browser;
            # "application/xhtml+xml" = browser;
            # "application/xhtml_xml" = browser;
            # "application/rdf+xml" = browser;
            # "application/rss+xml" = browser;
            # "application/x-extension-htm" = browser;
            # "application/x-extension-html" = browser;
            # "application/x-extension-shtml" = browser;
            # "application/x-extension-xht" = browser;
            # "application/x-extension-xhtml" = browser;
            # # define default applications for some url schemes.
            # "x-scheme-handler/about" = browser; # open `about:` url with `browser`
            # "x-scheme-handler/ftp" = browser; # open `ftp:` url with `browser`
            # "x-scheme-handler/http" = browser;
            # "x-scheme-handler/https" = browser;
          }
          // associations;
      };
  };
}
