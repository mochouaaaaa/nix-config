_:
let
  settings = ''
    [Settings]
    gtk-cursor-theme-name=Capitaine Cursors (Nord)
    gtk-icon-theme-name=WhiteSur-dark
    gtk-theme-name=WhiteSur-dark
    gtk-im-module=fcitx
  '';
in
{
  xdg.configFile = {
    "gtk-3.0/settings-dark.ini".text = settings;
    "gtk-4.0/settings-dark.ini".text = settings;
  };
}
