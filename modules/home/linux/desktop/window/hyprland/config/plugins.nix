{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.profiles.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      plugins = [
        # inputs.hypr-dynamic-cursors.packages.${pkgs.system}.hypr-dynamic-cursors
        # inputs.hyprgrass.packages.${pkgs.system}.default
        # inputs.hyprgrass.packages.${pkgs.system}.hyprgrass-pulse
        # inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
      ];
      extraConfig = "";
    };
  };
}
