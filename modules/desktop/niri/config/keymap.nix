{
  flake.modules.homeManager."desktop.niri" = { lib, pkgs, ... }: {

    wayland.windowManager.niri.settings.binds =
      let
        playerctl = lib.getExe pkgs.playerctl;

        default-params = {
          _props = {
            allow-inhibiting = false;
            repeat = false;
          };
        };
      in
      {
        "Mod+g" = default-params // {
          toggle-overview = { };
        };

        "Mod+Ctrl+t" = default-params // {
          spawn-sh = [ "kitty --single-instance" ];
        };

        "Mod+Ctrl+e" = default-params // {
          spawn = [ "nautilus" ];
        };

        "Mod+q" = default-params // {
          close-window = [ ];
        };

        "Ctrl+Alt+Return" = default-params // {
          fullscreen-window = [ ];
        };

        "Mod+Ctrl+a" = {
          screenshot._props.show-pointer = true;
        };

        "Mod+Ctrl+Print" = default-params // {
          # screenshot-screen = {
          #   show-pointer = false;
          #   write-to-disk = true;
          # };
          screenshot-screen = { };
        };

        "Mod+Ctrl+s" = default-params // {
          # screenshot-window._props.write-to-disk = true;
          screenshot-window = { };
        };

        "Mod+Escape".toggle-keyboard-shortcuts-inhibit = [ ];

        "Ctrl+Shift+left".set-column-width = "-10%";
        "Ctrl+Shift+right".set-column-width = "+10%";
        "Ctrl+Shift+up".set-window-height = "-2%";
        "Ctrl+Shift+down".set-window-height = "+2%";

        "Alt+h".focus-column-left = [ ];
        "Alt+l".focus-column-right = [ ];
        "Alt+j".focus-workspace-down = [ ];
        "Alt+k".focus-workspace-up = [ ];

        "XF86AudioPlay" = default-params // {
          spawn = [
            playerctl
            "play-pause"
          ];
        };

        "XF86AudioStop" = default-params // {
          spawn = [
            playerctl
            "pause"
          ];
        };

        "XF86AudioPrev" = default-params // {
          spawn = [
            playerctl
            "previous"
          ];
        };

        "XF86AudioNext" = default-params // {
          spawn = [
            playerctl
            "next"
          ];
        };
      };

  };
}
