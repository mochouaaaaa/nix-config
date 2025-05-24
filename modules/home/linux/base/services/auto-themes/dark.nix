{ config, lib, ... }:
let
  cfg = config.modules.themes.auto.gtkTheme;

  settings = ''
    [Settings]
    gtk-cursor-theme-name=WhiteSur-cursors
    gtk-icon-theme-name=WhiteSur-dark
    gtk-theme-name=WhiteSur-dark
  '';
in
{

  config = lib.mkIf cfg.enable {

    xdg.configFile = {
      "gtk-3.0/settings-dark.ini".text = settings;
      "gtk-4.0/settings-dark.ini".text = settings;
    };

  };
}
