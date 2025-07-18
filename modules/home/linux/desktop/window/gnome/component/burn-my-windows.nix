{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules.desktop.gnome.shell.packages.burn-my-windows;
in
{

  options.modules.desktop.gnome.shell.packages.burn-my-windows = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable the Burn My Windows extension in GNOME Shell.";
    };
  };

  config = lib.mkIf cfg.enable {

    programs.gnome-shell = {
      extensions = lib.mkAfter [
        { package = pkgs.gnomeExtensions.burn-my-windows; }
      ];
    };

    dconf.settings = {
      "org/gnome/shell/extensions/burn-my-windows" = {
        active-profile = "/home/mochou/.config/burn-my-windows/profiles/1742968467993684.conf";
        last-extension-version = 46;
        last-prefs-version = 46;
        prefs-open-count = 12;
      };
    };
  };
}
