{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.hyprland;
  cfgWaybar = config.modules.desktop.component.waybar;

in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      (writeShellScriptBin "refresh" ''

        ${lib.optionalString cfgWaybar.enable ''
          systemctl --user restart waybar.service
        ''}
        systemctl --user restart swaync.service

        exit 0
      '')
    ];
  };
}
