{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfgGnome = config.modules'.desktop.gnome;
  cfg = config.modules'.desktop.gnome.extensions."coverflow-alt-tab";
in
{
  config = lib.mkIf (cfgGnome.enable && cfg) {
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
