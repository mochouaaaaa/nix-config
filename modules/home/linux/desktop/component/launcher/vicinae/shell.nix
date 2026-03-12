{
  lib,
  config,
  ...
}:
with lib;
let
  cfgNoctalia = config.programs.noctalia-shell;
in
{
  config = mkMerge [

    (mkIf (cfgNoctalia.enable) {

      services.vicinae = {
        settings = {
          launcher_window = {
            opacity = lib.mkForce config.programs.noctalia-shell.settings.ui.panelBackgroundOpacity;
          };
        };
      };

    })

  ];
}
