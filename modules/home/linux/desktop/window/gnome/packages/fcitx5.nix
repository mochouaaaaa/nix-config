{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.gnome;
in
{
  config = lib.mkIf cfg.enable {

    home.sessionVariables = {
      GTK_IM_MODULE = "wayland";
    };

    dconf.settings = {
      "org/gnome/settings-daemon/plugins/xsettings" = {
        overrides = ''{'Gtk/IMModule': <'fcitx'>}'';
      };
    };

  };
}
