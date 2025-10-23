{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfgGnome = config.modules'.desktop.gnome;
  cfg = config.modules'.desktop.gnome.shell.packages.coverflow-alt-tab;
in
{

  options.modules'.desktop.gnome.shell.packages.coverflow-alt-tab = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the coverflow-alt-tab extension.";
    };
  };

  config = lib.mkIf (cfgGnome.enable && cfg.enable) {

    programs.gnome-shell = {
      extensions = [
        { package = pkgs.gnomeExtensions.coverflow-alt-tab; }
      ];
    };

    dconf.settings = {
      "org/gnome/shell/extensions/coverflowalttab" = {
        # dim-factor = 0.98999999999999999;
        # switcher-background-color = lib.gvariant.mkTuple [
        #   lib.gvariant.mkString
        #   "0.25098039215686274"
        #   lib.gvariant.mkString
        #   "0.25098039215686274"
        #   lib.gvariant.mkString
        #   "0.25098039215686274"
        # ];

        # switcher-looping-method = "Flip Stack";
      };
    };
  };
}
