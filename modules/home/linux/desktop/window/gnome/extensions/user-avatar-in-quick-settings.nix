{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfgGnome = config.modules'.desktop.gnome;
  cfg = config.modules'.desktop.gnome.extensions."user-avatar-in-quick-settings";
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
