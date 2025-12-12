{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {

    wayland.windowManager.hyprland = {
      settings = {
        exec-once = [
          "hyprctl setcursor ${config.home.pointerCursor.name} ${builtins.toString config.home.pointerCursor.size}"
          "${lib.getExe pkgs.dconf} write /org/gnome/desktop/interface/cursor-theme '${config.home.pointerCursor.name}'"
          "${lib.getExe pkgs.dconf} write /org/gnome/desktop/interface/cursor-size '${builtins.toString config.home.pointerCursor.size}'"
        ];
      };
    };
  };
}
