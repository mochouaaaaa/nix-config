{
  lib,
  pkgs,
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
        listener =
          let
            lockscreen-dpms = pkgs.writeShellScriptBin "lockscreen-dpms" ''
              LOCKED=$(loginctl show-session "$XDG_SESSION_ID" -p LockedHint | cut -d= -f2)
              if [ "$LOCKED" = "yes" ]; then
                  echo "🔒 已锁屏，允许息屏"
                  hyprctl dispatch dpms off
               else
                  echo "🖥 未锁屏，不息屏"
               fi
            '';
          in
          lib.mkForce [
            {
              timeout = 600;
              on-timeout = "loginctl lock-session";
            }
            {
              timeout = 180;
              on-timeout = "${lib.getExe lockscreen-dpms}";
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
