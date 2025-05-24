{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.hyprland;
in
{

  config = lib.mkIf cfg.enable {

    programs'.waybar'.settings = {
      modules-left = lib.mkAfter [ "hyprland/window" ];
      modules-center = lib.mkAfter [
        "hyprland/workspaces#icon"
      ];
    };

    programs.waybar = {
      systemd = {
        target = lib.mkForce "hyprland-session.target";
      };

    };

  };
}
