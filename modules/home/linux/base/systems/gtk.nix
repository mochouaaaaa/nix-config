{
  lib,
  pkgs,
  config,
  ...
}:
let
  overrideCursors = pkgs.whitesur-cursors.overrideAttrs (oldAttrs: {
    src = pkgs.fetchFromGitHub {
      owner = "vinceliuice";
      repo = "WhiteSur-cursors";
      rev = "master";
      hash = "sha256-hFtfq8F6KeqUEBlypPCr/EKq6rif/g868vJd8c06c1I=";
    };
  });
in
{

  config = lib.mkIf (config.programs.desktop.enable) {

    # If your themes for mouse cursor, icons or windows don’t load correctly,
    # try setting them with home.pointerCursor and gtk.theme,
    # which enable a bunch of compatibility options that should make the themes load in all situations.
    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = overrideCursors;
      name = "WhiteSur-cursors";
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

    # 当不使用gtk时需要设置
    home.sessionVariables.GTK2_RC_FILES = config.gtk.gtk2.configLocation;
    gtk = {
      enable = false;
    };

  };
}
