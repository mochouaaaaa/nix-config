{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      (writeShellScriptBin "refresh" ''

        ${lib.optionalString config.programs.waybar.enable ''
          systemctl --user restart waybar.service
        ''}
        systemctl --user restart swaync.service

        exit 0
      '')
    ];
  };
}
