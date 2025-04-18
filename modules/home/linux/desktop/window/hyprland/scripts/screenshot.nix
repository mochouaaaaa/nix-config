{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      (writeShellScriptBin "screenshot" ''

        iDIR="$HOME/.config/swaync/icons"
        notify_cmd_shot="notify-send -h string:x-canonical-private-synchronous:shot-notify -u low -i ''${iDIR}/screenshot.png"

        # Function: Notify and handle sound
        notify_view() {
            local msg=$1
            local success=$2
            if [[ "$success" -eq 1 ]]; then
                ''${notify_cmd_shot} "$msg"
                sounds --screenshot
            fi
        }

        # Function: Capture selected area
        capture_area() {
            grimblast --freeze copy area
            if [[ $? -eq 0 ]]; then
                notify_view "Screenshot copied to clipboard" 1
            fi
        }

        # Function: Capture with swappy
        capture_with_swappy() {
            grimblast --freeze copysave active $HOME/Pictures/Screenshots/screenshot.png
            if [[ $? -eq 0 ]]; then
                notify_view "Screenshot save to file" 1
            fi
        }

        # Screenshot options
        case "$1" in
        --area)
            capture_area
            ;;
        --active)
            capture_active_window
            ;;
        *)
            echo -e "Available Options: --win --area --active --swappy"
            ;;
        esac

        exit 0
      '')
    ];
  };
}
