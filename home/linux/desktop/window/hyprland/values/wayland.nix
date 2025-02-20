{
  pkgs,
  lib,
  nur-ryan4yin,
  ...
}: let
  package = pkgs.hyprland;
in {
  # wayland.windowManager.hyprland = {
  #   xwayland.enable = true;
  #   enable = true;
  #   settings = {
  #     config = builtins.readFile ../hypr/hyprland.conf;
  #     source = "${
  #       nur-ryan4yin.packages.${pkgs.system}.catppuccin-hyprland
  #     }/themes/mocha.conf";
  #     env = [
  #       "NIXOS_OZONE_WL,1" # for any ozone-based browser & electron apps to run on wayland
  #       "_JAVA_AWT_WM_NONREPARENTING,1"
  #     ];
  #   };
  #   systemd = {
  #     enable = true;
  #     variables = ["--all"];
  #   };
  # };
  #
  # home.file = {
  #   ".wayland-session" = {
  #     source = "${package}/bin/Hyprland";
  #     executable = true;
  #   };
  #   ".config/hypr" = {
  #     source = ../hypr;
  #     recursive = true;
  #     force = true;
  #   };
  # };
}
