{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop;
in
{
  config = lib.mkIf (cfg.hyprland.enable || cfg.niri.enable || cfg.gnome.enable) {

    home.packages = [
      pkgs.loupe
    ];

    xdg.mimeApps = {
      defaultApplications = {
        "image/png" = [ "org.gnome.Loupe.desktop" ];
        "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
        "image/webp" = [ "org.gnome.Loupe.desktop" ];
        "image/gif" = [ "org.gnome.Loupe.desktop" ];
      };
    };

  };

}
