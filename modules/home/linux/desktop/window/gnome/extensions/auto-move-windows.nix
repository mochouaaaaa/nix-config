{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfgGnome = config.profiles.desktop.gnome;
  cfg = config.profiles.desktop.gnome.extensions.auto-move-windows;
in
{
  config = lib.mkIf (cfgGnome.enable && cfg) {
    programs.gnome-shell = {
      extensions = [
        { package = pkgs.gnomeExtensions.auto-move-windows; }
      ];
    };

    dconf.settings = {
      "org/gnome/shell/extensions/auto-move-windows" = {
        "application-list" = [
          "firefox.desktop:2"
          "com.obsproject.Studio.desktop:4"
        ];
      };
    };
  };
}
