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
  config = lib.mkIf (cfgHyprland.enable && cfgNoctalia.enable) {

    modules'.desktop.services.vicinae.enable = true;

    services.vicinae = {
      enable = lib.mkForce true;
      settings = {
        window = {
          opacity = lib.mkForce config.modules'.desktop.shell.noctalia.settings.ui.panelBackgroundOpacity;
        };
      };
    };

  };
}
