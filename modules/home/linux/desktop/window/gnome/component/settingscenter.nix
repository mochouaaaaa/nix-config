{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfgGnome = config.modules'.desktop.gnome;
  cfg = config.modules'.desktop.gnome.shell.packages.settingscenter;
in
{

  options.modules'.desktop.gnome.shell.packages.settingscenter = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable the Settings Center extension.";
    };
  };

  config = lib.mkIf (cfgGnome.enable && cfg.enable) {

    programs.gnome-shell = {
      extensions = lib.mkAfter [
        { package = pkgs.gnomeExtensions.settingscenter; }
      ];
    };

    dconf.settings = {
      "org/gnome/shell/extensions/SettingsCenter" = {
      };
    };
  };
}
