{
  mylib,
  lib,
  config,
  ...
}: let
  cfgDesktop = config.modules.desktop;
in {
  imports = mylib.scanPaths ./.;

  # config = lib.mkMerge [
  #   (lib.mkIf cfgDesktop.hyprland.enable {
  #     modules.desktop = {
  #       niri.enable = false;
  #       gnome.enable = false;
  #       kde.enable = false;
  #     };
  #   })
  #
  #   (lib.mkIf cfgDesktop.kde.enable {
  #     modules.desktop = {
  #       niri.enable = false;
  #       gnome.enable = false;
  #       hyprland.enable = false;
  #     };
  #   })
  # ];
}
