{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.desktop.hyprland;
in {
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      xwayland.enable = true;
      plugins = [
        inputs.hypr-dynamic-cursors.packages.${pkgs.system}.hypr-dynamic-cursors
        # inputs.hypr-darkwindow.packages.${pkgs.system}.Hypr-DarkWindow
      ];
      systemd = {
        enable = false;
        variables = ["--all"];
        enableXdgAutostart = true;
      };
      extraConfig = ''

        $configs = $HOME/.config/hypr/configs

        source=$configs/settings.conf
        source=$configs/keybinds.conf
        source=$configs/envs.conf
        source=$configs/monitors.conf
        source=$configs/startups.conf
        source=$configs/userDecorAnimations.conf
        source=$configs/windowRules.conf

        source=$HOME/.config/hypr/plugins/default.conf
      '';
    };

    xdg.configFile = {
      # "hypr/hyprland.conf".enable = false;
      "hypr/colors" = {
        force = true;
        source = ./colors;
        recursive = true;
      };
      "hypr/configs" = {
        force = true;
        source = ./configs;
        recursive = true;
      };
      "hypr/plugins" = {
        force = true;
        source = ./plugins;
        recursive = true;
      };
    };
  };
}
