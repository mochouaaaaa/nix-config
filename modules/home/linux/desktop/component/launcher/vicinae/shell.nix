{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfgNoctalia = config.modules'.desktop.shell.noctalia;
in
{
  config = mkMerge [

    (mkIf (cfgNoctalia.enable) {

      services.vicinae = {
        settings = {
          launcher_window = {
            opacity = lib.mkForce config.modules'.desktop.shell.noctalia.settings.ui.panelBackgroundOpacity;
          };
        };
      };

    })

  ];
}
