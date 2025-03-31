{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  cfgHyprland = config.modules.desktop.hyprland;
in {
  options.modules.desktop.hyprland = {
    enable = lib.mkEnableOption "Hyprland";
  };
  config = lib.mkIf cfgHyprland.enable {
    modules.dm.greetd.enable = true;

    programs = {
      hyprland = {
        enable = true;
        withUWSM = true;
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      };
      # hyprlux = hyprlux.hyprlux;

      uwsm = {
        enable = true;
      };
      regreet = {
        enable = true;
      };
      # thunar file manager(part of xfce) related options
      # thunar = {
      #   enable = true;
      #   plugins = with pkgs.xfce; [
      #     thunar-archive-plugin
      #     thunar-volman
      #     thunar-media-tags-plugin
      #   ];
      # };
    };

    environment.systemPackages = with pkgs; [cage];

    services = {
      xserver = {
        enable = true;
      };
      greetd = {
        settings = {
          default_session = {
            command = lib.mkForce "cage -s -mlast ${lib.getExe config.programs.regreet.package}";
          };
        };
      };
    };
  };
}
