{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfgGnome = config.modules'.desktop.gnome;
  cfg = config.modules'.desktop.gnome.shell.packages.rounded-window-corners-reborn;
in
{

  options.modules'.desktop.gnome.shell.packages.rounded-window-corners-reborn = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Rounded Window Corners Reborn extension.";
    };
  };

  config = lib.mkIf (cfgGnome.enable && cfg.enable) {

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
