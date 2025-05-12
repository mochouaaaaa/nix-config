{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules.desktop.gnome.shell.packages.appindicator;
in
{
  options.modules.desktop.gnome.shell.packages.appindicator = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {

    programs.gnome-shell = {
      extensions = lib.mkAfter [
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
