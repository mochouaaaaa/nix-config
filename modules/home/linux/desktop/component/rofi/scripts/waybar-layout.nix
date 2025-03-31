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
        writeShellScriptBin "waybar-layout" ''
          #!/usr/bin/env bash

          set -euo pipefail
          IFS=$'\n\t'

          # Define directories
          waybar_themes="$HOME/.config/waybar/themes"
          waybar_config="$HOME/.config/waybar/config"
          rofi_config="$HOME/.config/rofi/themes/waybar-layout.rasi"

          # Function to display menu options
          menu() {
              options=()
              while IFS= read -r file; do
                  options+=("''$(basename "''$file")")
              done < <(find -L "$waybar_themes" -maxdepth 1 -type f -exec basename {} \; | sort)

              printf '%s\n' "''${options[@]}"
          }

          # Apply selected configuration
          apply_config() {
              ln -sf "$waybar_themes/$1" "$waybar_config"
              restart_waybar_if_needed
          }

          # Restart Waybar
          restart_waybar_if_needed() {
              bash refresh
          }

          # Main function
          main() {
              choice=''$(menu | rofi -dmenu -config "$rofi_config")

              if [[ -z "$choice" ]]; then
                  echo "No option selected. Exiting."
                  exit 0
              fi

              case $choice in
                  "no panel")
                      pgrep -x "waybar" && pkill waybar || true
                      ;;
                  *)
                      apply_config "$choice"
                      ;;
              esac
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
