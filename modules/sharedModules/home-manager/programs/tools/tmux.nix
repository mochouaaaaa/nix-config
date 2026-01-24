{
  lib,
  pkgs,
  config,
  ...
}:
{
  home.packages = [
    pkgs.yq
  ];

  programs = {
    zsh.initContent = ''
      function zshexit() {
          if [ -n "$TMUX" ]; then
              # notify-send "Tmux" "Session Closed via Zsh"
              kitty @ set-user-vars IS_NVIM
          fi
      }
    '';
    tmux = {
      enable = true;
      package = pkgs.writeShellScriptBin "tmux" ''

        _tmux=${lib.getExe pkgs.tmux}

        if [[ $# -gt 0 ]]; then
            $_tmux "$@"
            exit $?
        fi

        $_tmux attach-session -t default 2>/dev/null || $_tmux new-session -s default
      '';

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

        bind r source-file ${config.xdg.configHome}/tmux/tmux.conf; display-message "Config Reloaded."
        set -g display-time 0

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
        bind-key -n M-h   if -F   "#{@pane-is-vim}" 'send-keys Escape "[104;137u"'  'select-pane -L'
        bind-key -n M-j   if -F   "#{@pane-is-vim}" 'send-keys Escape "[106;137u"'  'select-pane -D'
        bind-key -n M-k   if -F   "#{@pane-is-vim}" 'send-keys Escape "[107;137u"'  'select-pane -U'
        bind-key -n M-l   if -F   "#{@pane-is-vim}" 'send-keys Escape "[108;137u"'  'select-pane -R'

        bind-key -n C-S-h if -F   "#{@pane-is-vim}" 'send-keys Escape "[104;134u"' 'resize-pane -L 3'
        bind-key -n C-S-j if -F   "#{@pane-is-vim}" 'send-keys Escape "[106;134u"' 'resize-pane -D 3'
        bind-key -n C-S-k if -F   "#{@pane-is-vim}" 'send-keys Escape "[107;134u"' 'resize-pane -U 3'
        bind-key -n C-S-l if -F   "#{@pane-is-vim}" 'send-keys Escape "[108;134u"' 'resize-pane -R 3'

        bind-key -n C-M-k if -F   "#{@pane-is-vim}" 'send-keys Escape "[107;141u"' 'split-window -v -c "#{pane_current_path}"'
        bind-key -n C-M-j if -F   "#{@pane-is-vim}" 'send-keys Escape "[106;141u"' 'split-window -v -c "#{pane_current_path}"'
        bind-key -n C-M-l if -F   "#{@pane-is-vim}" 'send-keys Escape "[108;141u"' 'split-window -h -c "#{pane_current_path}"'
        bind-key -n C-M-h if -F   "#{@pane-is-vim}" 'send-keys Escape "[104;141u"' 'split-window -h -c "#{pane_current_path}"'

        tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
        if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
            "bind-key -n 'C-\\' if -F \"#{@pane-is-vim}\" 'send-keys C-\\'  'select-pane -l'"
        if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
            "bind-key -n 'C-\\' if -F \"#{@pane-is-vim}\" 'send-keys C-\\\\'  'select-pane -l'"

        #: }}}

        #: Custom keys {{{

        bind-key -n M-w   if -F   "#{@pane-is-vim}" 'send-keys Escape "[119;137u"' 'kill-pane'
        bind-key -n M-e   if -F   "#{@pane-is-vim}" 'send-keys Escape "[101;137u"'
        bind-key -n M-s   if -F   "#{@pane-is-vim}" 'send-keys Escape "[115;137u"'
        bind-key -n M-f   if -F   "#{@pane-is-vim}" 'send-keys Escape "[102;137u"'  'display-panes -d 0'
        bind-key -n M-S-f if -F   "#{@pane-is-vim}" 'send-keys Escape "[102;138u"' 'send-keys Escape "[102;10u"'
        bind-key -n M-/   if -F   "#{@pane-is-vim}" 'send-keys Escape "[47;137u"'
        bind-key -n M-r   if -F   "#{@pane-is-vim}" 'send-keys Escape "[114;137u"' 'send-keys "yazi" Enter'

        bind-key -n M-S-h         swap-pane -t "{left-of}" 
        bind-key -n M-S-l         swap-pane -t "{right-of}"
        bind-key -n M-S-k         swap-pane -t "{up-of}"
        bind-key -n M-S-j         swap-pane -t "{down-of}"

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
        # %if #{TMUX}
        # set status-bg red
        # %endif

        # Refresh `status-left` and `status-right` more often, from every 15s to 5s
        set -g status-interval 5
        #: }}}

        # --- 启动与连接 (Attach/New) ---
        # 当创建一个新会话并自动连接时触发
        set-hook -g after-new-session  'run-shell "kitty @ set-user-vars IS_TMUX=1"'
        # 当连接（Attach）到一个已存在的会话时触发
        set-hook -g client-attached    'run-shell "kitty @ set-user-vars IS_TMUX=1"'
        # --- 退出与断开 (Detach/Exit) ---
        set-hook -g session-closed     'run-shell "kitty @ set-user-vars IS_TMUX"'
        # 当你按下 手动断开连接（Detach）但保留后台会话时触发
        set-hook -g client-detached    'run-shell "kitty @ set-user-vars IS_TMUX"'

      '';
      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = catppuccin;
          extraConfig =
            let

              catppuccinPath = "${catppuccin}/share/tmux-plugins/catppuccin";
              status_dir = "${catppuccin}/status";
              status_utils = "${catppuccin}/utils";

              reset = pkgs.writeShellScriptBin "reset" ''

                set -euo pipefail

                ${lib.getExe pkgs.ripgrep} -Io 'set\s+-[aFgopqsuUw]+\s+"?@([^\s]+(\w|_))"?' -r '@$1' ${catppuccinPath}/**/*.conf | uniq | xargs -n1 -P0 tmux set -Ugq

                modules=()

                for filepath in "${status_dir}"/*.conf; do
                    [ -e "$filepath" ] || continue
                    filename="$(basename "$filepath" .conf)"
                    modules+=("$filename")
                done

                for module in "''${modules[@]}"; do
                      conf_file="${status_dir}/''${module}.conf"

                      rg -Io 'set\s+-[aFgopqsuUw]+\s+"?@([^\s]+(\w|_))"?' -r '@$1' "$conf_file" | sed "s/\''${MODULE_NAME}/$module/g" | uniq | xargs -n1 -P0 tmux set -Ugq
                      rg -Io 'set\s+-[aFgopqsuUw]+\s+"?@([^\s]+(\w|_))"?' -r '@$1' "${status_utils}" | sed "s/\''${MODULE_NAME}/$module/g" | uniq | xargs -n1 -P0 tmux set -Ugq
                done
              '';

              # https://github.com/catppuccin/tmux/issues/426
              run = "tmux run-shell ${catppuccinPath}/catppuccin.tmux";

              dark = pkgs.writeShellScriptBin "dark" ''
                tmux run-shell ${lib.getExe reset}
                tmux set -g @catppuccin_flavor 'mocha'
                ${run}
              '';

              light = pkgs.writeShellScriptBin "light" ''
                tmux run-shell ${lib.getExe reset}
                tmux set -g @catppuccin_flavor 'latte'
                ${run}
              '';
            in
            ''
              set -g @catppuccin_window_status_style "custom"

              set -g @catppuccin_window_left_separator "#[bg=default,fg=#{@thm_surface_0}]#[bg=#{@thm_surface_0},fg=#{@thm_fg}]"
              set -g @catppuccin_window_right_separator "#[bg=default,fg=#{@thm_surface_0}]"
              set -g @catppuccin_window_current_left_separator "#[bg=default,fg=#{@thm_mauve}]#[bg=#{@thm_mauve},fg=#{@thm_bg}]"
              set -g @catppuccin_window_current_middle_separator "#[fg=#{@thm_mauve}]█"
              set -g @catppuccin_window_current_right_separator "#[bg=default,fg=#{@thm_surface_1}]"

              set -g @catppuccin_status_background "none"

              # Make the status line pretty and add some modules
              set -g status-right-length 100
              set -g status-left-length 100
              set -g status-left ""
              set -g status-right "#{E:@catppuccin_status_application} "
              set -agF status-right "#{E:@catppuccin_status_cpu} "
              set -ag status-right "#{E:@catppuccin_status_session} "

              # set -g status-right " %H:%M %d-%b-%y [#{client_theme}]"

              set -g status-position top
              set-hook -g client-light-theme 'run-shell ${lib.getExe light}'
              set-hook -g client-dark-theme 'run-shell ${lib.getExe dark}'

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
            set -g @continuum-save-interval '5'
            set -g @continuum-restore 'on'
          '';
        }
        fzf-tmux-url
      ];
    };
  };

}
