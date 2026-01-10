{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfgGnome = config.profiles.desktop.gnome;
  cfg = config.profiles.desktop.gnome.extensions."burn-my-windows";
in
{
  config = lib.mkIf (cfgGnome.enable && cfg) {
    programs.gnome-shell = {
      extensions = [
        { package = pkgs.gnomeExtensions.burn-my-windows; }
      ];
    };

    dconf.settings = {
      "org/gnome/shell/extensions/burn-my-windows" = {
        active-profile = "${config.xdg.configHome}/burn-my-windows/profiles/1742968467993684.conf";
        last-extension-version = 46;
        last-prefs-version = 46;
        prefs-open-count = 12;
      };
    };
  };
}
