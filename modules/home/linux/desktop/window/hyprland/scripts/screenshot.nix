{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.desktop.hyprland;
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      (
        writeShellScriptBin "screenshot" ''
          #!/usr/bin/env bash

          iDIR="$HOME/.config/swaync/icons"
          # notify_cmd_shot="notify-send -h string:x-canonical-private-synchronous:shot-notify -u low -i ''${iDIR}/picture.png"
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

          # Function: Take screenshot with grim
          take_shot() {
              local geometry=$1
              grim -g "$geometry" - | wl-copy
              if [[ $? -eq 0 ]]; then
                  notify_view "Screenshot copied to clipboard" 1
              fi
          }

          # Function: Countdown timer
          countdown() {
              local seconds=$1
              for sec in $(seq "$seconds" -1 1); do
                  notify-send -h string:x-canonical-private-synchronous:shot-notify -t 1000 -i "$iDIR/timer.png" "Taking shot in: $sec"
                  sleep 1
              done
          }

          # Function: Capture active window
          capture_active_window() {
              local geometry
              geometry=$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
              take_shot "$geometry"
          }

          # Function: Capture selected area
          capture_area() {
              local geometry
              geometry=$(slurp)
              if [[ -n "$geometry" ]]; then
                  take_shot "$geometry"
              fi
          }

          # Function: Capture with swappy
          capture_with_swappy() {
              local tmpfile
              tmpfile=$(mktemp)
              grim -g "$(slurp)" - >"$tmpfile" && wl-copy <"$tmpfile"
              if [[ -s "$tmpfile" ]]; then
                  swappy -f "$tmpfile"
                  notify_view "Screenshot edited and copied to clipboard" 1
              fi
              rm -f "$tmpfile"
          }

          # Screenshot options
          case "$1" in
          --now)
              take_shot ""
              ;;
          --in5)
              countdown 5
              take_shot ""
              ;;
          --in10)
              countdown 10
              take_shot ""
              ;;
          --win)
              capture_active_window
              ;;
          --area)
              capture_area
              ;;
          --active)
              capture_active_window
              ;;
          --swappy)
              capture_with_swappy
              ;;
          *)
              echo -e "Available Options: --now --in5 --in10 --win --area --active --swappy"
              ;;
          esac

          exit 0
        ''
      )
    ];
  };
}
