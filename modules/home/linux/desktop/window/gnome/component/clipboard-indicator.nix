{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfgGnome = config.modules'.desktop.gnome;
  cfg = config.modules'.desktop.gnome.shell.packages.clipboard-indicator;
in
{

  options.modules'.desktop.gnome.shell.packages.clipboard-indicator = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable clipboard-indicator.";
    };
  };

  config = lib.mkIf (cfgGnome.enable && cfg.enable) {

    programs.gnome-shell = {
      extensions = [
        { package = pkgs.gnomeExtensions.clipboard-indicator; }
      ];
    };

    dconf.settings = {
      "org/gnome/shell/extensions/clipboard-indicator" = {
        enable-keybindings = lib.gvariant.mkBoolean true;
        cache-size = lib.gvariant.mkInt32 10;
        history-size = lib.gvariant.mkInt32 100;
        notify-on-copy = lib.gvariant.mkBoolean false;
        paste-on-select = lib.gvariant.mkBoolean true;
        pinned-on-bottom = lib.gvariant.mkBoolean true;
        toggle-menu = lib.gvariant.mkArray [ "<Super>p" ];
      };
    };
  };
}
