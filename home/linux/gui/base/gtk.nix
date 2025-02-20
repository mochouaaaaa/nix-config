{
  pkgs,
  config,
  ...
}: {
  # If your themes for mouse cursor, icons or windows don’t load correctly,
  # try setting them with home.pointerCursor and gtk.theme,
  # which enable a bunch of compatibility options that should make the themes load in all situations.

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.capitaine-cursors-themed;
    name = "Capitaine Cursors (Nord)";
    size = 24;
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
  gtk = {
    enable = true;

    font = {
      name = "Monaco Nerd Font";
      # package = pkgs.noto-fonts;
      size = 11;
    };

    # gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    #
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    #
    theme = {
      name = "WhiteSur-dark-nord"; # 或 "WhiteSur-light"，根据主题的具体名称调整
      package = pkgs.whitesur-gtk-theme.overrideAttrs {
        themeVariants = ["nord"];
        nautilusStyle = "mojave";
      };
    };
  };
}
