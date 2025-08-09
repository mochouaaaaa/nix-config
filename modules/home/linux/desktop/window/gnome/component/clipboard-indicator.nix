{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules'.desktop.gnome.shell.packages.clipboard-indicator;
in
{

  options.modules'.desktop.gnome.shell.packages.clipboard-indicator = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable clipboard-indicator.";
    };
  };

  config = lib.mkIf cfg.enable {

    programs.gnome-shell = {
      extensions = lib.mkAfter [
        { package = pkgs.gnomeExtensions.clipboard-indicator; }
      ];
    };

    dconf.settings = {
      "org/gnome/shell/extensions/clipboard-indicator" = {
        enable-keybindings = lib.gvariant.mkBoolean false;
        cache-size = lib.gvariant.mkInt32 10;
        history-size = lib.gvariant.mkInt32 100;
        notify-on-copy = lib.gvariant.mkBoolean false;
        paste-on-select = lib.gvariant.mkBoolean true;
        pinned-on-bottom = lib.gvariant.mkBoolean true;
      };
    };
  };
}
