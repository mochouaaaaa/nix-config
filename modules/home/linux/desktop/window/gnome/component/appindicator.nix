{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfgGnome = config.modules'.desktop.gnome;
  cfg = config.modules'.desktop.gnome.shell.packages.appindicator;
in
{
  options.modules'.desktop.gnome.shell.packages.appindicator = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf (cfgGnome.enable && cfg.enable) {

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
