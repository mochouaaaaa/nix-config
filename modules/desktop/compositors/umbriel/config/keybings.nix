{
  flake.modules.homeManager."desktop.umbriel" = {

    programs.umbriel.settings.keybinds = {
      "Mod+Space" = "spawn vicinae toggle";

      # Applications and session
      "Mod+Q" = {
        action = "window-close";
        repeat = false;
      };
      "Mod+Escape" = "session-quit";
      "Mod+Ctrl+Q" = {
        action = "spawn loginctl lock-session";
        repeat = false;
      };

      # Terminal and file manager
      "Mod+Ctrl+T" = "spawn kitty --single-instance --listen-on=unix:$XDG_RUNTIME_DIR/kitty";
      "Mod+Ctrl+E" = "spawn luciole";

      # Window state
      "Mod+Ctrl+F" = {
        action = "window-toggle-floating";
        repeat = false;
      };
      "Ctrl+Alt+Return" = {
        action = "window-toggle-fullscreen";
        repeat = false;
      };

      # Focus: preserve the existing ALT+HJKL compositor navigation.
      "Alt+H" = "window-focus-left";
      "Alt+J" = "workspace-next";
      "Alt+K" = "workspace-previous";
      # "Alt+J" = "window-focus-down";
      # "Alt+K" = "window-focus-up";
      "Alt+L" = "window-focus-right";

      # Move and resize
      # Umbriel uses primary extent for column width and secondary extent for row height.
      "Mod+Shift+H" = "window-modify-primary-extent -0.02";
      "Mod+Shift+L" = "window-modify-primary-extent +0.02";
      "Mod+Shift+K" = "window-modify-secondary-extent +0.02";
      "Mod+Shift+J" = "window-modify-secondary-extent -0.02";

      # Swap windows
      "Ctrl+Alt+Left" = "window-swap-left";
      "Ctrl+Alt+Right" = "window-swap-right";
      "Ctrl+Alt+Up" = "window-swap-up";
      "Ctrl+Alt+Down" = "window-swap-down";

      "Mod+g" = {
        action = "overview-toggle";
        repeat = false;
      };
      # Layout switching: scrolling -> dwindle -> master -> stacking.
      "Mod+Tab" = "workspace-set-layout toggle scrolling dwindle master stacking";

      # Window switching
      "Alt+Tab" = "window-focus-next";

      # Scrolling layout extent
      "Ctrl+Shift+R" = "window-cycle-primary-extent";

      # Workspaces
      "Mod+1" = "workspace-switch 1";
      "Mod+2" = "workspace-switch 2";
      "Mod+3" = "workspace-switch 3";
      "Mod+4" = "workspace-switch 4";
      "Mod+5" = "workspace-switch 5";
      "Mod+6" = "workspace-switch 6";

      "Mod+Shift+1" = "window-move-to-workspace 1";
      "Mod+Shift+2" = "window-move-to-workspace 2";
      "Mod+Shift+3" = "window-move-to-workspace 3";
      "Mod+Shift+4" = "window-move-to-workspace 4";
      "Mod+Shift+5" = "window-move-to-workspace 5";
      "Mod+Shift+6" = "window-move-to-workspace 6";

      # Scratchpads
      # "Mod+U" = "scratchpad-toggle default"
      # "Mod+Shift+U" = "window-move-to-scratchpad default"

      # "Mod+Ctrl+2" = "scratchpad-toggle tg";
      # "Mod+Ctrl+3" = "scratchpad-toggle wechat";
      # "Mod+Ctrl+4" = "scratchpad-toggle matrix";
      # "Mod+Ctrl+1" = "scratchpad-toggle music";

      # Noctalia
      "Mod+Comma" = "spawn noctalia msg settings-toggle";
      "Mod+Ctrl+a" = "spawn noctalia msg screenshot-region";

      # Media and volume
      "XF86AudioRaiseVolume" = {
        action = "spawn wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+";
        allow_when_locked = true;
      };
      "XF86AudioLowerVolume" = {
        action = "spawn wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        allow_when_locked = true;
      };
      "XF86AudioMute" = {
        action = "spawn wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        allow_when_locked = true;
        repeat = false;
      };
      "XF86AudioMicMute" = {
        action = "spawn wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        allow_when_locked = true;
        repeat = false;
      };

      # Brightness
      "XF86MonBrightnessUp" = {
        action = "spawn brightnessctl -e4 -n2 set 5%+";
        allow_when_locked = true;
      };
      "XF86MonBrightnessDown" = {
        action = "spawn brightnessctl -e4 -n2 set 5%-";
        allow_when_locked = true;
      };

      # Media playback
      "XF86AudioNext" = {
        action = "spawn playerctl next";
        allow_when_locked = true;
      };
      "XF86AudioPause" = {
        action = "spawn playerctl play-pause";
        allow_when_locked = true;
        repeat = false;
      };
      "XF86AudioPlay" = {
        action = "spawn playerctl play-pause";
        allow_when_locked = true;
        repeat = false;
      };
      "XF86AudioPrev" = {
        action = "spawn playerctl previous";
        allow_when_locked = true;
      };

    };
  };
}
