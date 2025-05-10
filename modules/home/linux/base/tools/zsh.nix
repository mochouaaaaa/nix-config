{ ... }:
{
  programs.zsh = {
    initContent = ''
      tmux() {
        if [[ -n "$*" ]]; then
          command tmux "$@"
        else
          exec command tmux
        fi
      }
    '';
  };
}
