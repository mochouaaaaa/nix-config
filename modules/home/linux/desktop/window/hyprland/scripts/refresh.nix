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
      (writeShellScriptBin "refresh" ''

        systemctl --user restart waybar.service
        systemctl --user restart swaync.service

        ln -sf "$HOME/.cache/wal/cava-colors" "$HOME/.config/cava/config" || true
        exit 0
      '')
    ];
  };
}
