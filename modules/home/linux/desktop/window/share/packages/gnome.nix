{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.profiles.desktop;

  packages = [
    pkgs.evince
    pkgs.file-roller
    pkgs.loupe
    pkgs.font-manager
    pkgs.nautilus
  ];
in
{

  config = lib.mkIf (cfg.hyprland.enable || cfg.niri.enable || cfg.gnome.enable) {

    home.packages = packages;

    xdg.mimeApps.defaultApplicationPackages = packages;

  };

}
