{ config, ... }:
{
  # https://github.com/junegunn/fzf/issues/4151
  # 还没开始实现

  programs = {
    zsh.envExtra = ''
      export RUNEWIDTH_EASTASIAN=0
      export FZF_COMPLETION_TRIGGER="**"

      export FZF_DEFAULT_COMMAND="fd --hidden --follow -I --exclude={Pods,.direnv,.git,.idea,.vscode,.sass-cache,node_modules,build} --type f"

      export FZF_DEFAULT_OPTS="--height 60%
        --layout reverse
        --ansi --tiebreak=chunk
        --preview 'cat {} || tree -N -C {}'
        --preview-window right:50%:wrap 
        --bind '?:toggle-preview'
        --border --color=border:4
        --cycle
        --select-1 --exit-0
        --color=fg:7,bg:-1,hl:6,fg+:7,bg+:8,hl+:6
        --color=info:5,prompt:4,pointer:1,marker:3,spinner:2,header:0"

      export FZF_CTRL_R_OPTS="--layout=reverse
        --no-sort
        --exact
        --preview 'echo {}'
        --preview-window down:3:hidden:wrap
        --bind '?:toggle-preview'
        --border
        --cycle" 

      export FZF_CTRL_T_COMMAND="fd --hidden --follow -I --exclude={Pods,.git,.idea,.vscode,.sass-cache,node_modules,build} --type f"
      export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"

      export FZF_ALT_C_COMMAND="fd --type d"
      export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

      # export FZF_TMUX_OPTS="-p 90%,80%" # 控制着fzf的window 是 popup 的还是 split panel 的
      zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
      zstyle ':fzf-tab:*' popup-pad 30 0
      zstyle ':fzf-tab:*' fzf-flags --preview-window=down:9:hidden:wrap
      zstyle ':fzf-tab:*' fzf-pad 4


    '';
    fzf = {
      enable = true;
      enableBashIntegration = false;
      enableZshIntegration = false;
      tmux = {
        enableShellIntegration = true;
        shellIntegrationOptions = [ "-p 90%,80%" ];
      };
    };
  };
}
