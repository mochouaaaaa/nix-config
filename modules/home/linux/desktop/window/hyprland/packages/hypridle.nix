{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.desktop.hyprland;
  cfgHypridle = config.profiles.desktop.hypridle;
in
{

  options.profiles.desktop.hypridle = {
    lock_cmd = lib.mkOption {
      type = lib.types.str;
      default = "hyprlock";
      description = "Command to lock the screen.";
    };
  };

  config = lib.mkIf (cfg.enable && !config.profiles.desktop.shell.dank-material-shell.enable) {
    services.hypridle = {
      enable = false;
      settings = {
        general = {
          lock_cmd = cfgHypridle.lock_cmd;
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = lib.mkDefault [
          {
            timeout = 600;
            on-timeout = cfgHypridle.lock_cmd;
          }
          {
            timeout = 180;
            on-timeout =
              let
                lock = pkgs.writeShellScriptBin "lockscreen-dpms" ''
                  LOCKED=$(loginctl show-session "$XDG_SESSION_ID" -p LockedHint | cut -d= -f2)
                  if [ "$LOCKED" = "yes" ]; then
                      echo "🔒 已锁屏，允许息屏"
                      hyprctl dispatch dpms on
                  else
                      echo "🖥 未锁屏，不息屏"
                  fi
                '';

              in
              "${lib.getExe lock}";
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
