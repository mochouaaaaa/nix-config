{
  flake.modules.homeManager."desktop.common" =
    {
      lib,
      config,
      pkgs,

      username,
      ...
    }:
    {
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

      xdg.mimeApps = lib.mkIf pkgs.stdenv.isLinux {
        defaultApplicationPackages = [ config.programs.firefox.package ];
      };

    };

  flake.modules.nixos.preservation =
    {
      lib,
      config,
      username,
      ...
    }:
    {
      profiles.preservation.users.${username}.directories =
        lib.optionals (config.home-manager.users.${username}.programs.firefox.enable)
          [
            ".config/mozilla"
            ".cache/mozilla"
          ];
    };

}
