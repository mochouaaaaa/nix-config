{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.niri;
in
{
  config = lib.mkIf cfg.enable {

    programs'.waybar'.settings = {
      modules-left = lib.mkAfter [ "niri/window" ];
      modules-center = lib.mkAfter [
        "niri/workspaces#icon"
      ];
    };

    programs.waybar = {
      systemd = {
        target = lib.mkForce "niri.service";
      };
    };

  };
}
