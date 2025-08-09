{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules'.themes.auto.gtkTheme;

  settings = ''
    [Settings]
    gtk-key-theme-name=Default
    gtk-theme-name=WhiteSur-Dark
    gtk-icon-theme-name=WhiteSur-dark
    gtk-font-name=Monaco Nerd Font 12
    gtk-cursor-theme-name=${config.home.pointerCursor.name}
    gtk-cursor-theme-size=${builtins.toString config.home.pointerCursor.size}
    gtk-button-images=0
    gtk-menu-images=0
    gtk-enable-event-sounds=0
    gtk-enable-input-feedback-sounds=0
    gtk-xft-antialias=1
    gtk-xft-hinting=1
    gtk-xft-hintstyle=hintslight
    gtk-xft-rgba=rgb
    gtk-application-prefer-dark-theme=0
  '';
in
{

  config = lib.mkIf cfg.enable {

    xdg.configFile = {
      "gtk-3.0/settings-dark.ini".text = settings;
      # "gtk-4.0/settings-dark.ini".text = settings;
    };

  };
}
