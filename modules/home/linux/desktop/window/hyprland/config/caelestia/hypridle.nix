{
  lib,
  config,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland.caelestia;
in
{
  config = lib.mkIf cfg.enable {
    services.hypridle = {
      settings = {
        general = {
          lock_cmd = lib.mkForce "caelestia shell lock lock";
        };
        listener = lib.mkForce [
          {
            timeout = 600;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 600;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 1800;
            on-timeout = "systemctl suspend-then-hibernate || loginctl suspend";
          }
        ];
      };
    };
  };

}
