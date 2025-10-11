{ lib, config, ... }:
let
  cfg = config.modules'.desktop;
in
{

  options = {
    programs = {
      wsl.enable = lib.mkEnableOption "if you want to use WSL";
      desktop.enable = lib.mkEnableOption "Desktop environment is enabled";
    };

    modules'.desktop = with lib; {

      gnome = {
        enable = mkOption {
          type = types.bool;
          default = builtins.getEnv "DESKTOP" == "gnome";
          description = "Enable GNOME desktop environment.";
        };
      };

      hyprland = {
        enable = lib.mkOption {
          default = builtins.getEnv "DESKTOP" == "hyprland";
          type = lib.types.bool;
          description = "Enable Hyprland desktop environment.";
        };
      };

      kde = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = builtins.getEnv "DESKTOP" == "kde";
          description = "Enable KDE desktop environment.";
        };
      };

      niri = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = builtins.getEnv "DESKTOP" == "niri";
          description = "Enable Niri window manager";
        };
      };

      sway = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = builtins.getEnv "DESKTOP" == "sway";
          description = "Enable Sway window manager";
        };
      };
    };
  };

  config = {
    programs.desktop.enable = lib.mkIf (
      cfg.gnome.enable || cfg.hyprland.enable || cfg.kde.enable || cfg.niri.enable || cfg.sway.enable
    ) true;
  };

}
