{
  lib,
  pkgs,
  config,
  ...
}:
{

  config = lib.mkIf (config.profiles.desktop.enable) (
    lib.mkMerge [
      {

        # If your themes for mouse cursor, icons or windows don’t load correctly,
        # try setting them with home.pointerCursor and gtk.theme,
        # which enable a bunch of compatibility options that should make the themes load in all situations.
        home.pointerCursor = {
          gtk.enable = true;
          x11.enable = true;
          package = pkgs.adwaita-icon-theme;
          name = "Adwaita";
          size = 36;
        };

        # set dpi for 4k monitor
        xresources.properties = {
          # dpi for Xorg's font
          "Xft.dpi" = 150;
          # or set a generic dpi
          "*.dpi" = 150;
        };

        # gtk's theme settings, generate files:
        #   1. ~/.gtkrc-2.0
        #   2. ~/.config/gtk-3.0/settings.ini
        #   3. ~/.config/gtk-4.0/settings.ini

        home.preferXdgDirectories = true;
        # 当不使用gtk时需要设置
        home.sessionVariables.GTK2_RC_FILES = config.gtk.gtk2.configLocation;
        gtk = {
          enable = false;
        };

      }
    ]
  );
}
