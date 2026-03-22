{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfg = config.profiles.packages.firefox;
in
{

  config = lib.mkIf (cfg.enable && config.profiles.desktop.enable) {

    home.activation = {
      active-firefox-theme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        rm -rf $HOME/.mozilla/firefox/mochou/user.js
        ${pkgs.firefox-gnome-theme}/bin/auto-install.sh
      '';
    };

    programs.firefox.profiles.${username} = {
      settings = {
        "ui.key.menuAccessKey" = 0;

        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.uidensity" = 0;
        "layers.acceleration.force-enabled" = true;
        "mozilla.widget.use-argb-visuals" = true;
        "widget.gtk.rounded-bottom-corners.enabled" = true;
        "widget.gtk.non-native-titlebar-buttons.enabled" = false;
        "svg.context-properties.content.enabled" = true;

        "gnomeTheme.hideSingleTab" = true;
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
