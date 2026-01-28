{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfgGnome = config.profiles.desktop.gnome;
  cfg = config.profiles.desktop.gnome.extensions.just-perfection;
in
{
  config = lib.mkIf (cfgGnome.enable && cfg) {
    programs.gnome-shell = {
      extensions = [
        { package = pkgs.gnomeExtensions.just-perfection; }
      ];
    };

    dconf.settings = {
      "org/gnome/shell/extensions/just-perfection" = {
        accent-color-icon = false;
        activities-button = false;
        animation = 6;
        clock-menu = true;
        controls-manager-spacing-size = 0;
        double-super-to-appgrid = false;
        keyboard-layout = true;
        notification-banner-position = 2;
        overlay-key = false;
        panel = true;
        panel-button-padding-size = 0;
        panel-icon-size = 0;
        panel-indicator-padding-size = 0;
        panel-size = 0;
        quick-settings-airplane-mode = false;
        quick-settings-dark-mode = true;
        quick-settings-night-light = true;
        startup-status = 0;
        support-notifier-showed-version = 34;
        support-notifier-type = 0;
        top-panel-position = 0;
        weather = false;
        workspace-background-corner-size = 0;
        world-clock = false;
      };
    };
  };
}
