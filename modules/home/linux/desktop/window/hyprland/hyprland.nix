{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      xwayland.enable = true;
      plugins = [
        pkgs.hyprlandPlugins.hypr-dynamic-cursors
      ];
      systemd = {
        enable = true;
        variables = [ "--all" ];
        enableXdgAutostart = true;
      };
      settings = {
        env = [
          "NIXOS_OZONE_WL,1" # for any ozone-based browser & electron apps to run on wayland
          "MOZ_ENABLE_WAYLAND,1" # for firefox to run on wayland
          "MOZ_WEBRENDER,1"
        ];
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
