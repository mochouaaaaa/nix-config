{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfgGnome = config.modules'.desktop.gnome;
  cfg = config.modules'.desktop.gnome.extensions."rounded-window-corners-reborn";
in
{
  config = lib.mkIf (cfgGnome.enable && cfg) {
    programs.gnome-shell = {
      extensions = [
        { package = pkgs.gnomeExtensions.rounded-window-corners-reborn; }
      ];
    };

    dconf.settings = {
      "org/gnome/shell/extensions/rounded-window-corners-reborn" = {
        enable-preferences-entry = true;
        skip-libhandy-app = true;
        tweak-kitty-terminal = true;
      };
    };
  };
}
