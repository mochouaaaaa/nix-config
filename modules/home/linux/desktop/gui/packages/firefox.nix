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

    programs.firefox = {
      package = pkgs.firefox-bin;
      configPath = "${config.xdg.configHome}/mozilla/firefox";
      profiles.${username} = {
        settings = {
          # "ui.key.menuAccessKey" = 0;
          #
          # "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          # "browser.uidensity" = 0;
          # "layers.acceleration.force-enabled" = true;
          # "mozilla.widget.use-argb-visuals" = true;
          # "widget.gtk.rounded-bottom-corners.enabled" = true;
          # "widget.gtk.non-native-titlebar-buttons.enabled" = false;
          # "svg.context-properties.content.enabled" = true;
          #
          # "gnomeTheme.hideSingleTab" = true;
        };
      };
    };

    xdg.mimeApps = {
      defaultApplicationPackages = [ config.programs.firefox.package ];
    };
  };
}
