{
  pkgs,
  lib,
  ...
}:
{
  # If your themes for mouse cursor, icons or windows don’t load correctly,
  # try setting them with home.pointerCursor and gtk.theme,
  # which enable a bunch of compatibility options that should make the themes load in all situations.
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.capitaine-cursors-themed;
    name = "Capitaine Cursors (Nord) - White";
    size = 48;
  };

  # set dpi for 4k monitor
  xresources.properties = {
    # dpi for Xorg's font
    "Xft.dpi" = 150;
    # or set a generic dpi
    "*.dpi" = 150;
  };

  # home.file = {
  #   ".cache/switch-theme.dark".enable = lib.mkDefault false;
  #   ".cache/switch-theme.light" = {
  #     text = ''light'';
  #     enable = lib.mkDefault true;
  #   };
  # };

  qt = lib.mkDefault {
    style.name = "adwaita";
    platformTheme.name = "gtk3";
    enable = true;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = lib.gvariant.mkString "prefer-light";
      cursor-theme = lib.gvariant.mkString "Capitaine Cursors (Nord) - White";
      gtk-theme = lib.gvariant.mkString "Adwaita-light";
      # gtk-theme = lib.gvariant.mkString "WhiteSur-light";
      icon-theme = lib.gvariant.mkString "WhiteSur-light";
    };
  };

  # gtk's theme settings, generate files:
  #   1. ~/.gtkrc-2.0
  #   2. ~/.config/gtk-3.0/settings.ini
  #   3. ~/.config/gtk-4.0/settings.ini
  gtk = {
    enable = false;

    theme = {
      name = "WhiteSur-light";
    };
    iconTheme = {
      name = "WhiteSur-light";
    };
    cursorTheme = {
      name = "Capitaine Cursors (Nord) - White";
    };
  };
}
