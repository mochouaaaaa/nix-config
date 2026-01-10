{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfgGnome = config.profiles.desktop.gnome;
  cfg = config.profiles.desktop.gnome.extensions."user-avatar-in-quick-settings";
in
{
  config = lib.mkIf (cfgGnome.enable && cfg) {
    programs.gnome-shell = {
      extensions = [
        { package = pkgs.gnomeExtensions.user-avatar-in-quick-settings; }
      ];
    };

    dconf.settings = {
      "org/gnome/shell/extensions/quick-settings-avatar" = {
        avatar-hostname = false;
        avatar-nobackground = true;
        avatar-position = 1;
        avatar-realname = false;
        avatar-size = 43;
        avatar-username = false;
      };
    };
  };
}
