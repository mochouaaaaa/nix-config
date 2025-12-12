{
  lib,
  config,
  ...
}:
let
  cfgHyprland = config.modules'.desktop.hyprland;
  cfgNoctalia = config.modules'.desktop.shell.noctalia;
in
{
  imports = lib.importModule' ./.;

  config = lib.mkIf (cfgHyprland.enable && cfgNoctalia.enable) {

    modules'.desktop.shell.noctalia = {
      settings = rec {
        ui = {
          panelBackgroundOpacity = lib.mkForce 0.44;
        };
        appLauncher = {
          backgroundOpacity = ui.panelBackgroundOpacity;
          customLaunchPrefix = lib.mkForce "hyprctl dispatch exec ";
        };
        bar = {
          backgroundOpacity = ui.panelBackgroundOpacity;
        };
        notifications = {
          backgroundOpacity = ui.panelBackgroundOpacity;
        };
        osd = {
          backgroundOpacity = ui.panelBackgroundOpacity;
        };
      };
    };

  };
}
