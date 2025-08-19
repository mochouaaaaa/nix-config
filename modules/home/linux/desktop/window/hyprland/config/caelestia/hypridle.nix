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
    home.packages = [
      (pkgs.writeShellScriptBin "lockscreen-dpms" ''
        LOCKED=$(loginctl show-session "$XDG_SESSION_ID" -p LockedHint | cut -d= -f2)
        if [ "$LOCKED" = "yes" ]; then
            echo "🔒 已锁屏，允许息屏"
            hyprctl dispatch dpms off
         else
            echo "🖥 未锁屏，不息屏"
         fi
      '')
    ];
    services.hypridle = {
      settings = {
        general = {
          lock_cmd = lib.mkForce "caelestia shell lock lock";
        };
      };
    };
  };

}
