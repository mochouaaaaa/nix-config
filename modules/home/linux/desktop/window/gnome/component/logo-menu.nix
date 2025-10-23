{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfgGnome = config.modules'.desktop.gnome;
  cfg = config.modules'.desktop.gnome.shell.packages.logo-menu;
in
{
  options.modules'.desktop.gnome.shell.packages.logo-menu = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable the Logo Menu extension.";
    };
  };

  config = lib.mkIf (cfgGnome.enable && cfg.enable) {

    programs.gnome-shell = {
      extensions = [
        { package = pkgs.gnomeExtensions.logo-menu; }
      ];
    };

    dconf.settings = {
      "org/gnome/shell/extensions/Logo-menu" = {
        hide-forcequit = true;
        hide-icon-shadow = true;
        hide-softwarecentre = true;
        menu-button-icon-click-type = 3;
        menu-button-icon-image = 18;
        menu-button-software-center = "";
        menu-button-system-monitor = "";
        menu-button-terminal = "kutty";
        show-power-options = true;
        symbolic-icon = false;
        use-custom-icon = false;
      };
    };
  };
}
