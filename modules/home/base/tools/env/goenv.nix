{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.packages.envs.goenv;

  goenv = pkgs.fetchgit {
    url = "https://github.com/go-nv/goenv.git";
    hash = "sha256-KOisRNvpx3hGTxtB23JqeQnIYlZzV6v/y5ZHgJy3+pw=";
  };
in
{
  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "env/goenv" = {
        source = goenv;
        recursive = true;
        force = true;
      };
    };
    programs.zsh.initExtra = lib.mkOrder 2050 ''
      export GOPROXY=https://goproxy.cn,direct
      export GOSUMDB=sum.golang.google.cn
      export GOENV_DISABLE_GOPATH=1

      export GOENV_ROOT="$HOME/.config/env/goenv"
      export PATH="$GOENV_ROOT/bin:$GOENV_ROOT/shims:$PATH"

      if (( $+commands[goenv] )) &>/dev/null; then
          _sukka_lazyload_command_goenv() {
              eval "$(goenv init -)"
          }

          _sukka_lazyload_completion_goenv() {
              source "$GOENV_ROOT/completions/goenv.zsh"
          }

          _lazyload_add_command goenv
          _lazyload_add_completion goenv
      fi
    '';
  };
}
