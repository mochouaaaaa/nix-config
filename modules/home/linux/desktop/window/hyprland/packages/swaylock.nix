{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
  cfg-lock = config.modules'.desktop.component.swaylock;
  cfgQuick = config.modules'.desktop.hyprland.caelestia;
in
{

  config = lib.mkIf (cfg.enable && cfg-lock.enable && !cfgQuick.enable) {

    home.packages = with pkgs; [

      (writeShellScriptBin "Dpms" ''
        if pgrep swaylock > /dev/null; then
            hyprctl dispatch dpms off
        fi
      '')
    ];

  };
}
