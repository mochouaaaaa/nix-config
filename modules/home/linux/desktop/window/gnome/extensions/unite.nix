{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfgGnome = config.profiles.desktop.gnome;
  cfg = config.profiles.desktop.gnome.extensions.unite;
in
{
  config = lib.mkIf (cfgGnome.enable && cfg) {
    programs.gnome-shell = {
      extensions = [
        { package = pkgs.gnomeExtensions.unite; }
      ];
    };

    dconf.settings = {
      "org/gnome/shell/extensions/unite" = {
        app-menu-ellipsize-mode = lib.hm.gvariant.mkString "end";
        show-window-title = lib.hm.gvariant.mkString "tiled";
        window-buttons-placement = lib.hm.gvariant.mkString "first";
        app-menu-max-width = 0;
        autofocus-windows = true;
        enable-titlebar-actions = true;
        extend-left-box = false;
        greyscale-tray-icons = true;
        hide-app-menu-icon = true;
        hide-window-titlebars = "never";
        icon-scale-workaround = false;
        notifications-position = "right";
        reduce-panel-spacing = true;
        restrict-to-primary-screen = true;
        show-appmenu-button = true;
        show-desktop-name = false;
        show-legacy-tray = true;
        show-window-buttons = "tiled";
        use-activities-text = true;
        window-buttons-theme = "mcmojave";
      };
    };
  };
}
