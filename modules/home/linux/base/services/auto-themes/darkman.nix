{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules'.themes.auto;
in
{
  options.modules'.themes.auto = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable auto-theme based on time and location.";
    };
    gtkTheme = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable GTK theme.";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = (
          pkgs.colloid-gtk-theme.override {
            tweaks = [ "black" ];
          }
        );
        description = "GTK theme package.";
      };
      shellTheme = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "window shell theme.";
      };
      icon = {
        name = lib.mkOption {
          type = lib.types.str;
          default = "Colloid";
          description = "Name of GTK icon theme.";
        };
        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.colloid-icon-theme;
          description = "Icon theme package.";
        };
      };
      name = lib.mkOption {
        type = lib.types.str;
        default = "Colloid";
        description = "Name of GTK theme.";
      };
      dark = lib.mkOption {
        type = lib.types.str;
        default = "Dark";
        description = "Name of GTK dark theme.";
      };
      light = lib.mkOption {
        type = lib.types.str;
        default = "Light";
        description = "Name of GTK light theme.";
      };
    };

  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      whitesur-icon-theme
      libadwaita
    ];

    services.darkman = {
      enable = true;
      settings = {
        lat = 39.9042;
        lng = 116.4074;
        usegeoclue = true;
        portal = true;
      };
    };
  };
}
