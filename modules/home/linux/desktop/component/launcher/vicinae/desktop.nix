{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfgDesktop = config.profiles.desktop;
in
{
  config = mkMerge [

    (mkIf (cfgDesktop.hyprland.enable) {

      wayland.windowManager.hyprland = {
        extraConfig = ''
          layerrule {
              name = vicinae
              match:namespace = vicinae

              blur = on
              ignore_alpha = 0
          }
        '';
      };

    })

    (mkIf (cfgDesktop.kde.enable) {

      services.vicinae.enable = true;

    })

    (mkIf (cfgDesktop.gnome.enable) {

      programs.gnome-shell = {
        extensions = [
          { package = pkgs.gnomeExtensions.vicinae; }
        ];
      };

    })

  ];
}
