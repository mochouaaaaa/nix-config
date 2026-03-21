{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfgGnome = config.profiles.desktop.gnome;
  cfg = config.profiles.desktop.gnome.extensions.user-themes;

  theme = pkgs.orchis-theme.override {
    tweaks = [ "compact" ];
  };
in
{
  config = lib.mkIf (cfgGnome.enable && cfg) {
    programs.gnome-shell = {
      extensions = [
        # { package = pkgs.gnomeExtensions.user-themes; }
      ];
      theme = {
        name = "Orchis-Light";
        package = theme;
      };

    };

    profiles.themes.gtkTheme = {
      name = "Orchis";
      package = theme;
      dark = "Dark";
      light = "Light";
    };

  };
}
