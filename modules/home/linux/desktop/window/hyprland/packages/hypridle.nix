{
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
in
{
  config = lib.mkIf (cfg.enable) {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = lib.mkDefault "hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = lib.mkDefault [
          {
            timeout = 600;
            on-timeout = "Dpms";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 600;
            on-timeout = "Lock";
          }
          {
            timeout = 1800;
            on-timeout = "systemctl hibernate";
            on-resume = "hyprctl reload";
          }
        ];
      };
    };
  };
}
