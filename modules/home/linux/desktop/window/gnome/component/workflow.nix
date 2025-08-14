{ config, lib, ... }:
let
  cfgGnome = config.modules'.desktop.gnome;
in
{
  config = lib.mkIf cfgGnome.enable {

    dconf.settings = {
      "org/gnome/desktop/wm/preferences" = {
        num-workspaces = 4;
      };
      "org/gnome/mutter" = {
        dynamic-workspaces = false;
      };
    };

  };
}
