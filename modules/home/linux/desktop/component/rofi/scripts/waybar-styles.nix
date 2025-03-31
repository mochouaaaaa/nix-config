{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.programs.rofi;
in {
  config = lib.mkIf (config.programs.waybar.enable
    && cfg.enable) {
    home.packages = with pkgs; [
      (
        writeShellScriptBin "waybar-style" ''
          #!/usr/bin/env bash

          set -euo pipefail
          IFS=$'\n\t'

          # Define directories
          waybar_colors="$HOME/.config/waybar/colors"
          waybar_style="$HOME/.config/waybar/style.css"
          rofi_config="$HOME/.config/rofi/themes/waybar-style.rasi"

          # Function to display menu options
          menu() {
              options=()
              while IFS= read -r file; do
                  if [ -f "$waybar_colors/$file" ]; then
                      options+=("$(basename "$file" .css)")
                  fi
              done < <(find -L "$waybar_colors" -maxdepth 1 -type f -name '*.css' -exec basename {} \; | sort)

              printf '%s\n' "''${options[@]}"
          }

          # Apply selected style
          apply_style() {
              ln -sf "$waybar_colors/$1.css" "$waybar_style"
              restart_waybar_if_needed
          }

          # Restart Waybar if it's running
          restart_waybar_if_needed() {
              refresh
          }

          # Main function
          main() {
              choice=$(menu | rofi -dmenu -config "$rofi_config")

              if [[ -z "$choice" ]]; then
                  echo "No option selected. Exiting."
                  exit 0
              fi

              apply_style "$choice"
          }

          # Kill Rofi if already running before execution
          if pgrep -x "rofi" >/dev/null; then
              pkill rofi
              exit 0
          fi

          main
        ''
      )
    ];
  };
}
