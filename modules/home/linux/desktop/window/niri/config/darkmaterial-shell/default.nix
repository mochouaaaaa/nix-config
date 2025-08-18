{
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.modules'.desktop.niri;
in
{
  imports = lib.importModule' ./. ++ [
    inputs.DankMaterialShell.homeModules.dankMaterialShell
  ];

  config = lib.mkIf cfg.enable {

    programs.dankMaterialShell = {
      enable = true;
      enableSpawn = false;
      enableSystemd = true;
    };

    # auto dark/light theme
    modules'.themes.auto = {
      enable = true;
      gtkTheme = {
        enable = true;
      };
    };

    services.darkman = {
      lightModeScripts = {
        gtk-theme = ''
          niri msg action do-screen-transition
          qs -c DankMaterialShell ipc call theme light
          switch-theme Light
        '';
      };
      darkModeScripts = {
        gtk-theme = ''
          niri msg action do-screen-transition
          qs -c DankMaterialShell ipc call theme dark
          switch-theme Dark
        '';
      };
    };

  };

}
