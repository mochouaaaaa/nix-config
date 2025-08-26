{
  lib,
  pkgs,
  ...
}:
{
  imports = lib.importModule' ./.;

  config = {
    environment.variables = {
      NIXOS_OZONE_WL = "1"; # 让 Electron 应用使用 Wayland
    };

    programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
  };

  options.modules'.desktop = with lib; {

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

  };

}
