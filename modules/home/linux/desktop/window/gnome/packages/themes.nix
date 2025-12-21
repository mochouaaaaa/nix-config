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

    modules'.themes.auto = {
      enable = true;
    };

    services.darkman = {
      lightModeScripts = {
        gtk-theme = ''
          switch-theme Light
          vicinae vicinae://theme/set/vicinae-light
        '';
      };
      darkModeScripts = {
        gtk-theme = ''
          switch-theme Dark
          vicinae vicinae://theme/set/vicinae-dark
        '';
      };
    };

  };
}
