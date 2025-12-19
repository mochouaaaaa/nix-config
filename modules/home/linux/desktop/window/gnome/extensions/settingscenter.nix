{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfgGnome = config.modules'.desktop.gnome;
  cfg = config.modules'.desktop.gnome.extensions.settingscenter;
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
