{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfgGnome = config.profiles.desktop.gnome;
  cfg = config.profiles.desktop.gnome.extensions.clipboard-indicator;
in
{
  config = lib.mkIf (cfgGnome.enable && cfg) {
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
