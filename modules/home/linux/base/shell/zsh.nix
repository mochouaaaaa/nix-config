{ ... }:
{
  programs =
    let
      initContent = ''
        tmux() {

        if [[ -n "$*" ]]; then
            command tmux "$@"
            return $?
        fi

        if command tmux has-session -t default 2>/dev/null; then
            exec command tmux attach-session -t default
        else
            exec command tmux new-session -s default
        fi

        }
      '';

    in
    {
      zsh = {
        initContent = initContent;
      };
      bash = {
        initExtra = initContent;
      };
    };
}
