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
      in
      {
        "Mod+Ctrl+t".action.spawn = "kitty";
        "Mod+q".action = close-window;

        "Mod+Ctrl+e".action = spawn "nautilus";
        "Ctrl+Alt+Return".action = fullscreen-window;

        "Mod+Ctrl+a".action = screenshot;
        "Mod+Ctrl+Print".action.screenshot-screen.write-to-disk = true;
        "Mod+Ctrl+s".action.screenshot-window.write-to-disk = true;

        "Mod+Escape".action = toggle-keyboard-shortcuts-inhibit;

        "Ctrl+Shift+left".action = set-column-width "-10%";
        "Ctrl+Shift+right".action = set-column-width "+10%";
        "Ctrl+Shift+up".action = set-window-height "-2%";
        "Ctrl+Shift+down".action = set-window-height "+2%";

        "Alt+h".action = focus-column-left;
        "Alt+l".action = focus-column-right;
        "Alt+j".action = focus-window-down;
        "Alt+k".action = focus-window-up;

        # "Mod+Shift+down".action = move-window-down;
        # "Mod+Shift+up".action = move-window-up;

        "XF86AudioPlay".action = playerctl "play-pause";
        "XF86AudioStop".action = playerctl "pause";
        "XF86AudioPrev".action = playerctl "previous";
        "XF86AudioNext".action = playerctl "next";
      };

  };
}
