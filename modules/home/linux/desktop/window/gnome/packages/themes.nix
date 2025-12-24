{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.gnome;
in
{
  config = lib.mkIf cfg.enable {

    services.darkman = {
      lightModeScripts = {
        gtk-theme = ''
          switch-theme ${config.modules'.themes.gtkTheme.light}
          vicinae vicinae://theme/set/vicinae-light
        '';
      };
      darkModeScripts = {
        gtk-theme = ''
          switch-theme ${config.modules'.themes.gtkTheme.dark}
          vicinae vicinae://theme/set/vicinae-dark
        '';
      };
    };

  };
}
