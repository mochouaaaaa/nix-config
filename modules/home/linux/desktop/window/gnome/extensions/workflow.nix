{
  lib,
  config,
  ...
}:
let
  cfgGnome = config.profiles.desktop.gnome;
  cfg = config.profiles.desktop.gnome.extensions.workflow;
in
{
  config = lib.mkIf (cfgGnome.enable && cfg) {
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
