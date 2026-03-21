{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.desktop.gnome;
in
{
  config = lib.mkIf cfg.enable {

    services.darkman = {
      lightModeScripts = {
        gtk-theme = ''
          switch-theme light
          vicinae vicinae://theme/set/vicinae-light
        '';
      };
      darkModeScripts = {
        gtk-theme = ''
          switch-theme dark
          vicinae vicinae://theme/set/vicinae-dark
        '';
      };
    };

  };
}
