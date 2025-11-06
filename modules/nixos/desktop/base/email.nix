{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfgDesktop = config.modules'.desktop;
in
{
  config =
    lib.mkIf (config.programs.desktop.enable && (cfgDesktop.hyprland.enable || cfgDesktop.niri.enable))
      {

        programs.evolution = {
          enable = true;
          plugins = [ pkgs.evolution-ews ];
        };

      };
}
