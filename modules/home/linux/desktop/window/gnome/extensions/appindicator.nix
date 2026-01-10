{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfgGnome = config.profiles.desktop.gnome;
  # The option is now a simple boolean defined centrally.
  cfg = config.profiles.desktop.gnome.extensions.appindicator;
in
{
  # The 'options' block is removed from here and managed centrally.

  config = lib.mkIf (cfgGnome.enable && cfg) {
    programs.gnome-shell = {
      extensions = [
        { package = pkgs.gnomeExtensions.appindicator; }
      ];
    };

    dconf.settings = {
      "org/gnome/shell/extensions/appindicator" = {
        tray-pos = lib.hm.gvariant.mkString "right";
      };
    };
  };
}
