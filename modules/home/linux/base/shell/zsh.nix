{ ... }:
{
  programs =
    let
      initContent = ''
        tmux() {
          if [[ -n "$*" ]]; then
            command tmux "$@"
          else
            exec command tmux
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
