{ pkgs, ... }:
{
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    # alt-c
    changeDirWidgetCommand = ''
      --walker-skip .git,node_modules,target
    '';
    changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
    defaultCommand = "fd --hidden --follow -I --exclude={Pods,.git,.idea,.vscode,.sass-cache,node_modules,build} --type f";
    defaultOptions = [
      "--tmux"
      "--height 60%"
      "--layout reverse"
      "--sort"
      "--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -N -C {}) 2> /dev/null | head -500'"
      "--preview-window right:50%:wrap "
      "--bind '?:toggle-preview'"
      "--border"
      "--cycle"
      "--select-1 --exit-0"
    ];
    colors = {
      "bg+" = "#313244";
      bg = "#1e1e2e";
      spinner = "#f5e0dc";
      hl = "#f38ba8";
      fg = "##cdd6f4";
      header = "#f38ba8";
      info = "#cba6f7";
      pointer = "#f5e0dc";
      marker = "#f5e0dc";
      "fg+" = "#cdd6f4";
      prompt = "#cba6f7";
      "hl+" = "#f38ba8";
    };
    tmux = {
      enableShellIntegration = true;
      shellIntegrationOptions = [ "--height 60% --layout reverse" ];
    };
  };
}
