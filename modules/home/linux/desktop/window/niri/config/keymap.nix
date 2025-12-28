{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.modules'.desktop.niri;
in
{
  config = lib.mkIf cfg.enable {

    programs.niri.settings.binds =
      with config.lib.niri.actions;
      let
        playerctl = spawn "${lib.getExe pkgs.playerctl}";
        allow-inhibiting = false;
      in
      {
        "Mod+Ctrl+t" = {
          inherit allow-inhibiting;
          cooldown-ms = 1000;
          action.spawn = "kitty --single-instance";
        };
        "Mod+q".action = close-window;

        "Mod+Ctrl+e" = {
          inherit allow-inhibiting;
          action = spawn "nautilus";
        };
        "Ctrl+Alt+Return".action = fullscreen-window;

        "Mod+Ctrl+a" = {
          inherit allow-inhibiting;
          action.screenshot.show-pointer = true;
        };
        "Mod+Ctrl+Print" = {
          inherit allow-inhibiting;
          action.screenshot-screen.write-to-disk = true;
        };
        "Mod+Ctrl+s" = {
          inherit allow-inhibiting;
          action.screenshot-window.write-to-disk = true;
        };

        "Mod+Escape".action = toggle-keyboard-shortcuts-inhibit;

        "Ctrl+Shift+left".action = set-column-width "-10%";
        "Ctrl+Shift+right".action = set-column-width "+10%";
        "Ctrl+Shift+up".action = set-window-height "-2%";
        "Ctrl+Shift+down".action = set-window-height "+2%";

        "Alt+h".action = focus-column-left;
        "Alt+l".action = focus-column-right;
        "Alt+j".action = focus-workspace-down;
        "Alt+k".action = focus-workspace-up;

        # "Mod+Shift+down".action = move-window-down;
        # "Mod+Shift+up".action = move-window-up;

        "XF86AudioPlay" = {
          inherit allow-inhibiting;
          action = playerctl "play-pause";
        };
        "XF86AudioStop" = {
          inherit allow-inhibiting;
          action = playerctl "pause";
        };
        "XF86AudioPrev" = {
          inherit allow-inhibiting;
          action = playerctl "previous";
        };
        "XF86AudioNext" = {
          inherit allow-inhibiting;
          action = playerctl "next";
        };
      };

  };
}
