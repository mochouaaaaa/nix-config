{
  lib,
  config,
  ...
}:
let
  cfg = config.modules'.desktop.shell.dankMaterialShell;
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
          dms ipc call theme light
          switch-theme Light
          vicinae vicinae://theme/set/vicinae-light
        '';
      };
      darkModeScripts = {
        gtk-theme = ''
          dms ipc call theme dark
          switch-theme Dark
          vicinae vicinae://theme/set/vicinae-dark
        '';
      };
    };

  };
}
