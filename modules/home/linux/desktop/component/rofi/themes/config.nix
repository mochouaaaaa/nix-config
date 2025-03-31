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
    xdg.configFile."rofi/config.rasi" = {
      text = ''
        @theme "~/.config/rofi/themes/nova-dark.rasi"

        configuration{
            kb-row-down: "Super+j";
            kb-row-up: "Super+k";
            kb-row-left: "Super+h";
            kb-row-right: "Super+l";
        }
      '';
    };
  };
}
