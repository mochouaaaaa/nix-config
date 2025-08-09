{
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.niri;
in
{
  config = lib.mkIf cfg.enable {

    programs'.waybar'.settings = {
      modules-left = [
        "niri/workspaces#icon"
      ];
      modules-center = [
      ];
      modules-right = [
        "custom/swaylock"
      ];
    };

    programs.waybar = {
      systemd = {
        target = lib.mkForce "niri.service";
      };
    };

  };
}
