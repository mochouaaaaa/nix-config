{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
in
{

  config = lib.mkIf cfg.enable {

    programs'.waybar'.settings = {
      modules-left = [
        "hyprland/workspaces#icon"
      ];
      modules-center = [
      ];
      modules-right = [
        "custom/hyprlock"
      ];
    };

    programs.waybar = {
      systemd = {
        target = lib.mkForce "hyprland-session.target";
      };
    };
  };
}
