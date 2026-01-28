{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfgGnome = config.profiles.desktop.gnome;
  cfg = config.profiles.desktop.gnome.extensions.user-themes;
in
{
  config = lib.mkIf (cfgGnome.enable && cfg) {
    programs.gnome-shell = {
      extensions = [
        { package = pkgs.gnomeExtensions.user-themes; }
      ];
    };
  };
}
