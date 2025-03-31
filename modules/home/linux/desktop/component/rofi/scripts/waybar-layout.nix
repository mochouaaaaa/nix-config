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
    xdg.configFile = {
      "rofi/themes/waybar-layout.rasi".text = ''
        /* config - Launcher */

        configuration {
            modi:                       "drun,run";
            font:                       "JetBrains Mono Nerd Font 10";
            show-icons:                 true;
            drun-display-format:        "{name}";
            hover-select:               true;
        }

        /* config and colors ---- */
        @import "default.rasi"

        /* ---- Window ---- */
        window {
            location:                   center;
            anchor:                     center;
            border:                     1px;
            border-radius:              30px;

            width:                      55%;
        }

        /* Main Box ---------------------------------------- */
        mainbox {
            orientation:                horizontal;
            children:                   [ "img", "listbox"];
            background-color:           transparent;

            spacing:                    24px;
        }

        /* Listbox ------------------------------------------ */
        listbox {
            spacing:                     20px;
            background-color:            transparent;
            orientation:                 vertical;
            children:                    [ "inputbar", "message", "listview" ];
        }

        /* Listview ---------------------------------------- */
        listview {
            columns:                     2;
            lines:                       6;
            cycle:                       true;
            dynamic:                     true;
            scrollbar:                   false;
            layout:                      vertical;
            reverse:                     false;
            fixed-height:                true;
            fixed-columns:               true;

            spacing:                     16px;
            background-color:            transparent;
        }

        /* Image ----------------------------------------------- */
        img {
            padding:                    64px 128px;
            border-radius:              24px;
            background-image:           url("~/.current_wallpaper", height);
        }

        /* Inputbar ---------------------------------------------- */
        inputbar {
            children:                    [ "textbox-icon", "entry" ];

            border-radius:               12px;
            background-color:            @shade-bg;
            text-color:                  @text;

            spacing:                     0px;
            margin:                      0px;
            padding:                     14px;
        }

        textbox-icon {
            expand:                      false;
            background-color:            transparent;
            text-color:                  inherit;
            str: "<U+F002>  ";
        }

        /* Entry ----------------------------------------------- */
        entry {
            cursor:                     text;
            expand:                     false;
            placeholder-color:          inherit;
            placeholder:                "Select Waybar layout";

            background-color:           transparent;
            text-color:                 inherit;
        }

        /* ---- Elements ---- */
        element {
            cursor:                     pointer;
            background-color:           transparent;
            border-radius:              10px;
            padding:                    12px;
        }

        element-text {
            background-color:            transparent;
            text-color:                  inherit;
            cursor:                      inherit;
            vertical-align:              0.5;
            horizontal-align:            0.0;
        }
      '';
    };

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
