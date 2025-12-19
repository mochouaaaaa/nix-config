{
  lib,
  config,
  ...
}:
let
  cfgGnome = config.modules'.desktop.gnome;
  cfg = config.modules'.desktop.gnome.extensions.workflow;
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
