{
  lib,
  pkgs,
  config,
  profiles,
  ...
}:
let
  cfg = profiles.desktop;
in
{
  options = {
    profiles = {
      wsl = {
        enable = lib.mkEnableOption "if you want to use WSL";
        default = builtins.hasAttr "wsl" config;
      };

      desktop = with lib; {
        enable = lib.mkEnableOption "Desktop environment is enabled";

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
            description = "Enable Hyprland desktop manager";
          };
        };

        kde = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = builtins.getEnv "DESKTOP" == "kde";
            description = "Enable KDE desktop manager";
          };
        };

        niri = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = builtins.getEnv "DESKTOP" == "niri";
            description = "Enable Niri desktop manager";
          };
        };

        sway = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = builtins.getEnv "DESKTOP" == "sway";
            description = "Enable Sway desktop manager";
          };
        };

      };
    };
  };

  config = lib.mkIf cfg.enable {
    profiles.desktop.enable = cfg.enable;

    environment.variables = {
      NIXOS_OZONE_WL = "1"; # 让 Electron 应用使用 Wayland
    };

    programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
  };

}
