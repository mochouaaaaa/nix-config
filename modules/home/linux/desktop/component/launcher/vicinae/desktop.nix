{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfgDesktop = config.modules'.desktop;
in
{
  config = mkMerge [

    (mkIf (cfgDesktop.hyprland.enable) {

      services.vicinae.enable = true;

      wayland.windowManager.hyprland = {
        settings = {
          layerrule = [
            "blur, vicinae"
            "ignorealpha 0, vicinae"
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
