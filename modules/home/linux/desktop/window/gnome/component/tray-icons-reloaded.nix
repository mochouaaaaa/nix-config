{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfgGnome = config.modules'.desktop.gnome;
in
{
  config = lib.mkIf cfgGnome.enable {

    programs.gnome-shell = {
      extensions = lib.mkAfter [
        { package = pkgs.gnomeExtensions.tray-icons-reloaded; }
      ];
    };

    dconf.settings = {
      "org/gnome/shell/extensions/trayIconsReloaded" = {
        tray-position = lib.gvariant.mkString "right";
        icons-limit = lib.gvariant.mkInt32 4;
        icon-margin-horizontal = 0;
        icon-padding-horizontal = 0;
        icon-size = 22;
        invoke-to-workspace = true;
        position-weight = 0;
        tray-margin-right = 0;
        wine-behavior = true;
      };
    };

  };
}
