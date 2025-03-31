{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.programs.rofi;
in {
  config = lib.mkIf (config.programs.waybar.enable
    && cfg.enable) {
    home.packages = with pkgs; [
      inputs.rofi-tools.packages.${pkgs.system}.rofi-cliphist
      (
        writeShellScriptBin "clip-manager" ''
          #!/usr/bin/env bash

          while true; do
              result=$(
                  rofi -dmenu \
                      -kb-custom-1 "Super-d" \
                      -kb-row-down "Super-j" \
                      -kb-row-up "Super-k" \
                      -kb-row-left "Super-h" \
                      -kb-row-right "Super-l" \
                      -config ~/.config/rofi/themes/clip-manager.rasi < <(cliphist list)
              )

              case "$?" in
                  1)
                      exit
                      ;;
                  0)
                      case "$result" in
                          "")
                              continue
                              ;;
                          *)
                              cliphist decode <<<"$result" | wl-copy
                              exit
                              ;;
                      esac
                      ;;
                  10)
                      cliphist delete <<<"$result"
                      ;;
                  11)
                      cliphist wipe
                      ;;
              esac
          done
        ''
      )
    ];
  };
}
