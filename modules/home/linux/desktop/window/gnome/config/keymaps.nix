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
      "move-to-monitor-down" = [ "<Shift><Super>j" ];
      "move-to-monitor-left" = [ "<Shift><Super>h" ];
      "move-to-monitor-right" = [ "<Shift><Super>l" ];
      "move-to-monitor-up" = [ "<Shift><Super>k" ];
      "move-to-workspace-1" = [ "<Shift><Super>1" ];
      "move-to-workspace-2" = [ "<Shift><Super>2" ];
      "move-to-workspace-3" = [ "<Shift><Super>3" ];
      "move-to-workspace-4" = [ "<Shift><Super>4" ];
      move-to-workspace-last = [ ];
      move-to-workspace-left = [ ];
      move-to-workspace-right = [ ];
      panel-run-dialog = [ ];
      switch-applications = [ ];
      switch-applications-backward = [ ];
      switch-group = [ ];
      switch-group-backward = [ ];
      switch-input-source = [ ];
      "switch-input-source-backward" = [ ];
      switch-panels = [ ];
      "switch-panels-backward" = [ ];
      "switch-to-workspace-1" = [ "<Super>1" ];
      "switch-to-workspace-2" = [ "<Super>2" ];
      "switch-to-workspace-3" = [ "<Super>3" ];
      "switch-to-workspace-4" = [ "<Super>4" ];
      switch-to-workspace-last = [ ];
      switch-to-workspace-left = [ ];
      switch-to-workspace-right = [ ];
      switch-windows = [ "<Super>Tab" ];
      "switch-windows-backward" = [ "<Shift><Super>Tab" ];
      toggle-maximized = [ "<Control><Alt>Return" ];
      unmaximize = [ ];
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
      "toggle-application-view" = [ ];
      "toggle-message-tray" = [ ];
      "toggle-quick-settings" = [ ];
    };
    # custom keybindings
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
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
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>space";
      command = "albert toggle";
      name = "albert";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = "<Control><Super>e";
      command = "nautilus";
      name = "文件管理器";
    };
  };
}
