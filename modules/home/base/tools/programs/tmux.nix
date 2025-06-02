{
  pkgs,
  config,
  ...
}:
{
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    shortcut = "a";
    terminal = "tmux-256color";
    clock24 = true;
    aggressiveResize = true;
    baseIndex = 1;
    disableConfirmationPrompt = true;
    focusEvents = true;
    keyMode = "vi";
    mouse = true;
    newSession = false;
    sensibleOnTop = true;
    historyLimit = 3000;
    escapeTime = 100;
    # shell = ''''${SHELL} -l'';
    extraConfig = ''
      set-option -g default-command "''${SHELL} -l"

      bind r source-file ${config.home.homeDirectory}/.config/tmux/tmux.conf; display-message "Config Reloaded."

      set -ga terminal-overrides ",xterm-256color:Tc:clipboard"
      # Wezterm termianl Use
      set -g update-environment "IS_WEZTERM"

      # Turn the mouse on, but without copy mode dragging
      set -g mouse on
      bind m \
          set -g mouse on \;\
          display 'Mouse: ON'
      # set mouse off with prefix M
      bind M \
          set -g mouse off \;\
          display 'Mouse: OFF'

      # Enable the new keyboard protocol for Tmux, and applying to the applications inside it on demand
      set -s extended-keys on
      set -as terminal-features 'xterm*:extkeys'

      # No bells at all
      set -g bell-action none

      #: yazi config {{{
      set -g allow-passthrough all
      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM
      #}}}

      # Increase repeat time for repeatable commands
      set -g repeat-time 1000


      # kitty kitten show_key -m kitty 获取CSI, 或者使用cat
      #: Pane {{{
      # Smart pane switching with awareness of Neovim splits.
      bind-key -n M-h if -F "#{@pane-is-vim}" 'send-keys Escape "[104;9u"'  'select-pane -L'
      bind-key -n M-j if -F "#{@pane-is-vim}" 'send-keys Escape "[106;9u"'  'select-pane -D'
      bind-key -n M-k if -F "#{@pane-is-vim}" 'send-keys Escape "[107;9u"'  'select-pane -U'
      bind-key -n M-l if -F "#{@pane-is-vim}" 'send-keys Escape "[108;9u"'  'select-pane -R'

      bind-key -n C-S-h if -F "#{@pane-is-vim}" 'send-keys Escape "[104;6u"' 'resize-pane -L 3'
      bind-key -n C-S-j if -F "#{@pane-is-vim}" 'send-keys Escape "[106;6u"' 'resize-pane -D 3'
      bind-key -n C-S-k if -F "#{@pane-is-vim}" 'send-keys Escape "[107;6u"' 'resize-pane -U 3'
      bind-key -n C-S-l if -F "#{@pane-is-vim}" 'send-keys Escape "[108;6u"' 'resize-pane -R 3'

      bind-key -n C-M-k if -F "#{@pane-is-vim}" 'send-keys Escape "[107;13u"' 'split-window -v -c "#{pane_current_path}"'
      bind-key -n C-M-j if -F "#{@pane-is-vim}" 'send-keys Escape "[106;13u"' 'split-window -v -c "#{pane_current_path}"'
      bind-key -n C-M-l if -F "#{@pane-is-vim}" 'send-keys Escape "[108;13u"' 'split-window -h -c "#{pane_current_path}"'
      bind-key -n C-M-h if -F "#{@pane-is-vim}" 'send-keys Escape "[104;13u"' 'split-window -h -c "#{pane_current_path}"'

      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if -F \"#{@pane-is-vim}\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if -F \"#{@pane-is-vim}\" 'send-keys C-\\\\'  'select-pane -l'"

      #: }}}

      #: Custom keys {{{
      bind-key -n M-w if -F "#{@pane-is-vim}" 'send-keys Escape "[119;9u]"' 'kill-pane'
      bind-key -n M-e if -F "#{@pane-is-vim}" 'send-keys Escape "[101;9u"'
      bind-key -n M-s if -F "#{@pane-is-vim}" 'send-keys Escape "[115;9u"'
      bind-key -n M-f if -F "#{@pane-is-vim}" 'send-keys Escape "[102;9u"'  'display-panes -d 0'
      bind-key -n M-S-f if -F "#{@pane-is-vim}" 'send-keys Escape "[102;10u"' 'send-keys Escape "[102;10u"'
      bind-key -n M-/ if -F "#{@pane-is-vim}" 'send-keys Escape "[47;9u"'
      bind-key -n M-r if -F "#{@pane-is-vim}" 'send-keys Escape "[114;9u"' 'send-keys "yazi" Enter'
      #: }}}

      #: Window {{{
      # Highlight window when it has new activity
      setw -g monitor-activity on
      set -g visual-activity on

      # Start window/pane index at 1
      set -g base-index 1
      set -g pane-base-index 1
      # Re-number windows when one is closed
      set -g renumber-windows on
      #: }}}

      #: Session {{{
      bind q display-panes -d 0
      #: }}}

      #: Status {{{

      # If running inside tmux ($TMUX is set), then change the status line to red
      %if #{TMUX}
      set status-bg red
      %endif

      # Refresh `status-left` and `status-right` more often, from every 15s to 5s
      set -g status-interval 5
      #: }}}

    '';
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor "mocha"
          set -g @catppuccin_status_background "#{@thm_bg}"
          # set -g @catppuccin_status_background "none"
          set -g @catppuccin_window_status_style "rounded"

          # Make the status line pretty and add some modules
          set -g status-right-length 100
          set -g status-left-length 100
          set -g status-left ""
          set -g status-right "#{E:@catppuccin_status_application} "
          set -agF status-right "#{E:@catppuccin_status_cpu} "
          set -ag status-right "#{E:@catppuccin_status_session} "

          set -g @catppuccin_status_left_separator  ""
          set -g @catppuccin_status_connect_separator "no" # yes, no
          set -g @catppuccin_status_right_separator ""

          set -g status-position top
        '';
      }
      sensible
      battery
      cpu
      {
        plugin = tmux-fzf;
        extraConfig = ''
          TMUX_FZF_LAUNCH_KEY="C-f"
          TMUX_FZF_OPTIONS="-p -w 90% -h 60% -m"
        '';
      }
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-save-interval '10'
          set -g @continuum-restore 'on'
        '';
      }
      fzf-tmux-url
    ];
  };
}
