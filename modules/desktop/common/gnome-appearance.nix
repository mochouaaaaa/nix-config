{
  flake.modules.homeManager."desktop.gnome" = {
    dconf.settings = {
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "";
      };
    };
  };
}
