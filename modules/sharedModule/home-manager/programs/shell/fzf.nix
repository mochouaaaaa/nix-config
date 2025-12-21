{ pkgs, ... }:
{
  # https://github.com/junegunn/fzf/issues/4151
  # 还没开始实现

  # solving fzf border problems
  home.sessionVariables = {
    RUNEWIDTH_EASTASIAN = 0;
    FZF_COMPLETION_TRIGGER = "**";
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    defaultCommand = "fd --hidden --follow -I --exclude={Pods,.direnv,.git,.idea,.vscode,.sass-cache,node_modules,build} --type f";
    defaultOptions = [
      "--height 60%"
      "--layout reverse"
      "--ansi --tiebreak=chunk"
      "--preview 'cat {} || tree -N -C {}'"
      "--preview-window right:50%:wrap "
      "--bind '?:toggle-preview'"
      "--border"
      "--cycle"
      "--select-1 --exit-0"
      "--color=fg:7,bg:0,hl:6,fg+:7,bg+:8,hl+:6"
      "--color=info:5,prompt:4,pointer:1,marker:3,spinner:2,header:0"
    ];
    # CTRL-R
    historyWidgetOptions = [
      "--layout=reverse"
      "--no-sort"
      "--exact"
      "--preview 'echo {}'"
      "--preview-window down:3:hidden:wrap"
      "--bind '?:toggle-preview'"
      "--border"
      "--cycle"
    ];
    # CTRL-T
    fileWidgetCommand = "fd --hidden --follow -I --exclude={Pods,.git,.idea,.vscode,.sass-cache,node_modules,build} --type f";
    fileWidgetOptions = [
      "--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
    ];
    # alt-c
    changeDirWidgetCommand = "fd --type d";
    # --walker-skip .git,node_modules,target

    changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
    tmux = {
      enableShellIntegration = true;
      shellIntegrationOptions = [ "-p 90%,80%" ];
    };
  };
}
