{
  dconf.settings = {
    "org/gnome/desktop/wm/keybindings" = {
      activate-window-menu = [ ];
      begin-move = [ ];
      begin-resize = [ ];
      close = [ "<Super>q" ];
      cycle-group = [ ];
      cycle-group-backward = [ ];
      cycle-panels = [ ];
      cycle-panels-backward = [ ];
      cycle-windows = [ ];
      cycle-windows-backward = [ ];
      maximize = [ ];
      minimize = [ ];
      move-to-monitor-down = [ ];
      move-to-monitor-left = [ ];
      move-to-monitor-right = [ ];
      move-to-monitor-up = [ ];
      move-to-workspace-1 = [ "<Shift><Super>1" ];
      move-to-workspace-2 = [ "<Shift><Super>2" ];
      move-to-workspace-3 = [ "<Shift><Super>3" ];
      move-to-workspace-4 = [ "<Shift><Super>4" ];
      move-to-workspace-down = [ ];
      move-to-workspace-last = [ ];
      move-to-workspace-left = [ ];
      move-to-workspace-right = [ ];
      move-to-workspace-up = [ ];
      panel-run-dialog = [ ];
      switch-applications = [ ];
      switch-applications-backward = [ ];
      switch-group = [ ];
      switch-group-backward = [ ];
      switch-input-source = [ ];
      switch-input-source-backward = [ ];
      switch-panels = [ ];
      switch-panels-backward = [ ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-down = [ ];
      switch-to-workspace-last = [ ];
      switch-to-workspace-left = [ ];
      switch-to-workspace-right = [ ];
      switch-to-workspace-up = [ ];
      switch-windows = [ "<Super>Tab" ];
      switch-windows-backward = [ "<Shift><Super>Tab" ];
      toggle-maximized = [ "<Control><Alt>Return" ];
      unmaximize = [ ];
    };
    "org/gnome/mutter/keybindings" = {
      cancel-input-capture = [ ];
      switch-monitor = [ ];
      toggle-tiled-left = [ "<Control><Alt>Left" ];
      toggle-tiled-right = [ "<Control><Alt>Right" ];
    };
    "org/gnome/shell/keybindings" = {
      "focus-active-notification" = [ ];
      "screenshot" = [ ];
      "screenshot-window" = [ "<Control><Super>s" ];
      "show-screen-recording-ui" = [ ];
      "show-screenshot-ui" = [ "<Control><Super>a" ];
      "switch-to-application-1" = [ ];
      "switch-to-application-2" = [ ];
      "switch-to-application-3" = [ ];
      "switch-to-application-4" = [ ];
      "shift-overview-down" = [ ];
      "shift-overview-up" = [ ];
      "toggle-application-view" = [ ];
      "toggle-message-tray" = [ ];
      "toggle-quick-settings" = [ ];
      "open-new-window-application-1" = [ ];
      "open-new-window-application-2" = [ ];
      "open-new-window-application-3" = [ ];
      "open-new-window-application-4" = [ ];
      "open-new-window-application-5" = [ ];
      "open-new-window-application-6" = [ ];
      "open-new-window-application-7" = [ ];
      "open-new-window-application-8" = [ ];
      "open-new-window-application-9" = [ ];
    };
    # custom keybindings
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
      ];
      help = [ ];
      logout = [ ];
      magnifier = [ ];
      "magnifier-zoom-in" = [ "<Super>equal" ];
      "magnifier-zoom-out" = [ "<Super>minus" ];
      screenreader = [ ];
      screensaver = [ "<Control><Super>q" ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Control><Super>t";
      command = "kitty";
      name = "kitty";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = "<Control><Super>e";
      command = "nautilus";
      name = "文件管理器";
    };
  };
}
