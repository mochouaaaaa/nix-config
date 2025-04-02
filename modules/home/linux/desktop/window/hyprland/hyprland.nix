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
        # inputs.hyprland-plugins.packages.${pkgs.system}.hyprtrails
        # inputs.hyprland-plugins.packages.${pkgs.system}.xtra-dispatchers
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
