{
  lib,
  config,
  ...
}:
let
  cfg = config.modules'.desktop.shell.caelestia;
in
{

  config = lib.mkIf (cfg.enable) {

    modules'.themes.auto = {
      enable = true;
      gtkTheme = {
        enable = true;
        shellTheme = "${lib.getExe config.programs.caelestia.cli.package} scheme set -f latte  -n catppuccin -m light";
      };
    };

    services.darkman = {
      lightModeScripts = {
        gtk-theme = ''
          caelestia scheme set -f latte  -n catppuccin -m light
          switch-theme Light
        '';
      };
      darkModeScripts = {
        gtk-theme = ''
          caelestia scheme set -f mocha -n catppuccin -m dark
          switch-theme Dark
        '';
      };
    };

  };
}
