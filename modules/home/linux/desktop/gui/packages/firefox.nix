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
        rm -rf ${config.xdg.configHome}/mozilla/firefox/mochou/user.js
        ${pkgs.firefox-gnome-theme}/bin/auto-install.sh

        rm -rf $HOME/.mozilla
        ln -sfT ${config.xdg.configHome}/mozilla $HOME/.mozilla
      '';
    };

    programs.firefox = {
      package = pkgs.firefox-bin;
      profiles.${username} = {
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
    };

    xdg.mimeApps = {
      defaultApplicationPackages = [ config.programs.firefox.package ];
    };
  };
}
