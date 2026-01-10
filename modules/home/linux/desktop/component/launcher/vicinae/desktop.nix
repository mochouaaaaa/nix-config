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
        settings = {
          layerrule = [
            "blur on, match:namespace vicinae"
            "ignore_alpha 0, match:namespace vicinae"
          ];
        };
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
