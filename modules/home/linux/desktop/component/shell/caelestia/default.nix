{
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.modules'.desktop.shell.caelestia;
in
{

  imports = lib.importModule' ./. ++ [
    inputs.caelestia-shell.homeManagerModules.default
  ];

  options.modules'.desktop.shell.caelestia = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable caelestia Shell integration";
    };
  };

  config = lib.mkIf (cfg.enable) {

    programs.caelestia = {
      enable = true;
      cli = {
        enable = true;
      };
    };

    modules'.themes.auto = {
      enable = true;
      gtkTheme.enable = true;
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
