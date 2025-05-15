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
    # package = pkgs.capitaine-cursors-themed;
    package = pkgs.whitesur-cursors;
    # name = "Capitaine Cursors (Nord)";
    name = "WhiteSur Cursors";
    size = 32;
  };

  # set dpi for 4k monitor
  xresources.properties = {
    # dpi for Xorg's font
    "Xft.dpi" = 150;
    # or set a generic dpi
    "*.dpi" = 150;
  };

  qt = lib.mkDefault {
    style.name = "adwaita";
    platformTheme.name = "gtk3";
    enable = true;
  };

  # gtk's theme settings, generate files:
  #   1. ~/.gtkrc-2.0
  #   2. ~/.config/gtk-3.0/settings.ini
  #   3. ~/.config/gtk-4.0/settings.ini
  gtk = {
    enable = false;

    gtk2 = {
      extraConfig = ''
        gtk-im-module=fcitx;
      '';
    };
    gtk3 = {
      extraConfig = ''
        gtk-im-module=fcitx;
      '';
    };
    gtk4 = {
      extraConfig = ''
        gtk-im-module=fcitx;
      '';
    };

    # theme = {
    #   name = "WhiteSur-light";
    # };
    # iconTheme = {
    #   name = "WhiteSur-light";
    # };
    # cursorTheme = {
    #   name = "Capitaine Cursors (Nord) - White";
    # };
  };
}
