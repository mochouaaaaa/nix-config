{
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.modules'.desktop.shell.dankMaterialShell;
in
{
  imports = lib.importModule' ./. ++ [
    inputs.DankMaterialShell.homeModules.dankMaterialShell.default
    inputs.DankMaterialShell.homeModules.dankMaterialShell.niri
  ];

  options.modules'.desktop.shell.dankMaterialShell = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Noctalia's Hyprland module";
    };
  };

  config = lib.mkIf cfg.enable {

    programs.dankMaterialShell = {
      enable = true;
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
          dms ipc call theme toggle
          switch-theme Light
        '';
      };
      darkModeScripts = {
        gtk-theme = ''
          niri msg action do-screen-transition
          dms ipc call theme toggle
          switch-theme Dark
        '';
      };
    };
  };

}
