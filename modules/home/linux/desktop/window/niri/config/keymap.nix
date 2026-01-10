{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.profiles.desktop.niri;
in
{
  config = lib.mkIf cfg.enable {

    programs.niri.settings.binds =
      let
        playerctl = "${lib.getExe pkgs.playerctl}";
        default-params = {
          allow-inhibiting = false;
          repeat = false;
        };
      in
      {
        "Mod+Ctrl+t" = default-params // {
          action.spawn-sh = "kitty --single-instance";
        };
        "Mod+Ctrl+e" = default-params // {
          action.spawn = "nautilus";
        };

        "Mod+q" = default-params // {
          action.close-window = [ ];
        };

        "Ctrl+Alt+Return" = default-params // {
          action.fullscreen-window = [ ];
        };

        "Mod+Ctrl+a" = {
          action.screenshot.show-pointer = true;
        };
        "Mod+Ctrl+Print" = default-params // {
          action.screenshot-screen = {
            show-pointer = false;
            write-to-disk = true;
          };
        };
        "Mod+Ctrl+s" = default-params // {
          action.screenshot-window = {
            show-pointer = false;
            write-to-disk = true;
          };
        };

        "Mod+Escape".action.toggle-keyboard-shortcuts-inhibit = [ ];

        "Ctrl+Shift+left".action.set-column-width = "-10%";
        "Ctrl+Shift+right".action.set-column-width = "+10%";
        "Ctrl+Shift+up".action.set-window-height = "-2%";
        "Ctrl+Shift+down".action.set-window-height = "+2%";

        "Alt+h".action.focus-column-left = [ ];
        "Alt+l".action.focus-column-right = [ ];
        "Alt+j".action.focus-workspace-down = [ ];
        "Alt+k".action.focus-workspace-up = [ ];

        # "Mod+Shift+down".action = move-window-down;
        # "Mod+Shift+up".action = move-window-up;

        "XF86AudioPlay" = {
          action.spawn = "${playerctl}  play-pause";
        }
        // default-params;
        "XF86AudioStop" = {
          action.spawn = "${playerctl}  pause";
        }
        // default-params;
        "XF86AudioPrev" = {
          action.spawn = "${playerctl}  previous";
        }
        // default-params;
        "XF86AudioNext" = {
          action.spawn = "${playerctl}  next";
        }
        // default-params;
      };

  };
}
