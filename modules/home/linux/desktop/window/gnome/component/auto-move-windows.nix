{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules.desktop.gnome.shell.packages.auto-move-windows;
in
{
  options.modules.desktop.gnome.shell.packages.auto-move-windows = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {

    programs.gnome-shell = {
      extensions = lib.mkAfter [
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
