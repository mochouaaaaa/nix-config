{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.profiles.desktop;
  isDesktopEnable =
    cfg.gnome.enable || cfg.hyprland.enable || cfg.kde.enable || cfg.niri.enable || cfg.sway.enable;
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

        cosmic = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = builtins.getEnv "DESKTOP" == "cosmic";
            description = "Enable Cosmic desktop environment.";
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

  config = lib.mkIf isDesktopEnable {
    profiles.desktop.enable = true;

    environment.variables = {
      NIXOS_OZONE_WL = "1"; # 让 Electron 应用使用 Wayland
    };

    programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
  };

}
