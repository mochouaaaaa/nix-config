{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfgGnome = config.profiles.desktop.gnome;
  cfg = config.profiles.desktop.gnome.extensions.settingscenter;
in
{
  config = lib.mkIf (cfgGnome.enable && cfg) {
    programs.gnome-shell = {
      extensions = [
        { package = pkgs.gnomeExtensions.settingscenter; }
      ];
    };

    dconf.settings = {
      "org/gnome/shell/extensions/SettingsCenter" = {
      };
    };
  };
}
