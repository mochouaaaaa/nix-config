{
  lib,
  config,
  ...
}:
let
  cfg = config.modules'.desktop.shell.noctalia;
in
{

  config = lib.mkIf (cfg.enable) {

    modules'.themes.auto = {
      enable = true;
      gtkTheme.enable = true;
    };

    services.darkman = {
      lightModeScripts = {
        gtk-theme = ''
          noctalia-shell ipc call darkMode setLight
          switch-theme Light
          vicinae vicinae://theme/set/vicinae-light
        '';
      };
      darkModeScripts = {
        gtk-theme = ''
          noctalia-shell ipc call darkMode setDark
          switch-theme Dark
          vicinae vicinae://theme/set/vicinae-dark
        '';
      };
    };

  };
}
