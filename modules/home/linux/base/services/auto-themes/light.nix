_:
let
  settings = ''
    [Settings]
    gtk-cursor-theme-name=Capitaine Cursors (Nord) - White
    gtk-icon-theme-name=WhiteSur-light
    gtk-theme-name=WhiteSur-light
  '';
in
{
  xdg.configFile = {
    "gtk-3.0/settings-light.ini".text = settings;
    "gtk-4.0/settings-light.ini".text = settings;
  };
}
