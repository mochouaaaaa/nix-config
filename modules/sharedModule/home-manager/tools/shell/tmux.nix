{
  lib,
  pkgs,
  config,
  ...
}:
{
  home.packages = [
    pkgs.yq
    (pkgs.writeShellScriptBin "tmux_attch" ''
      tmux attach-session -t main 2>/dev/null || tmux new-session -s main
    '')
  ];

  programs = {
    tmux = {
      enable = true;
      package = pkgs.tmux.overrideAttrs (
        finalAttrs: prevAttrs: {
          pname = "tmux-master";
          version = "unstable-master";
          src = pkgs.fetchFromGitHub {
            owner = "tmux";
            repo = "tmux";
            rev = "7e439539377e272f37d18bb10dbff374b87acee6";
            hash = "sha256-YY9CJ2Z6hjC4kGjRswlps4hya5Lk/ksM9luJHW8Cags=";
          };
        }
      );
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
        bind-key -n M-w if -F "#{@pane-is-vim}" 'send-keys Escape "[119;9u"' 'kill-pane'
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
          plugin = mkTmuxPlugin rec {
            pluginName = "tmux-nerd-font-window-name";
            version = "v2.1.2";
            src = pkgs.fetchFromGitHub {
              owner = "joshmedeski";
              repo = "tmux-nerd-font-window-name";
              tag = "${version}";
              hash = "sha256-bnlOAfdBv5Rg4z1hu1jtdx5oZ6kAZE40K4zqLxmyYQE=";
            };
            rtpFilePath = "tmux-nerd-font-window-name.tmux";
          };
        }
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

  xdg.configFile."tmux/tmux-nerd-font-window-name.yml".source =
    let
      settingsFormat = pkgs.formats.yaml { };

      settings = {
        config = {
          fallback-icon = "?"; # show when no definition is found
          multi-pane-icon = ""; # show when window has multiple panes (blank by default)
          show-name = false; # show the window name with the icon (defaults to false)
          icon-position = "left"; # show the icon to the "left" or "right" of the window name (defaults to left)
        };
        icons = {
          nvim = "";
          vim = "";
          bash = "";
          htop = "󰓅";
          nvtop = "";
          root = "󰦣";
          lazygit = "";
          less = "";
          yazi = "󰇥";
          "python2.7" = "";
          "python3.10" = "";
          "python3.11" = "";
          "python3.12" = "";
          python3 = "";
          python = "";
        };
      };
    in
    settingsFormat.generate "tmux-nerd-font-window-name.yml" settings;
}
