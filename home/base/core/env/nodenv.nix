{
  pkgs,
  lib,
  myvars,
  ...
}: let
  nodenv-build = pkgs.fetchgit {
    url = "https://github.com/nodenv/node-build.git";
    hash = "sha256-j6M8zHwlZKeck6kAVDf6PdMfeQMgdNw6IwYnLaE4nbM=";
  };
  nodenv-vars = pkgs.fetchgit {
    url = "https://github.com/nodenv/nodenv-vars.git";
    hash = "sha256-o9lc21DmRvhDKPX14Fpo2tg8csNy+qvDJZPGd4pe3VM=";
  };
  nodenv-aliases = pkgs.fetchgit {
    url = "https://github.com/nodenv/nodenv-aliases.git";
    hash = "sha256-OxjEgY7tz8c2d9gm7Dle36EeEBPx2QS0bDctAExRcyA=";
  };

  nodenvEnable = myvars.envs.nodenv;
in {
  # home.packages = with pkgs;
  #   lib.optional nodenvEnable
  #   nodenv;

  home.file = lib.mkIf nodenvEnable {
    ".config/env/nodenv" = {
      source = pkgs.nodenv;
      recursive = true;
      force = true;
    };
    ".config/env/nodenv/plugins/node-build" = {
      source = nodenv-build;
      recursive = true;
      force = true;
    };
    ".config/env/nodenv/plugins/nodoenv-vars" = {
      source = nodenv-vars;
      recursive = true;
      force = true;
    };
    ".config/env/nodenv/plugins/nodenv-aliases" = {
      source = nodenv-aliases;
      recursive = true;
      force = true;
    };
    "${myvars.dotfilePath}/zsh/plugins/nodenv.zsh" = {
      text = ''
        export NODENV_ROOT="$HOME/.config/env/nodenv"
        export PATH="$NODENV_ROOT/bin:$NODENV_ROOT/shims:$PATH"

        source $HOME/${myvars.dotfilePath}/zsh/plugins/lazyZsh.zsh

        if (( $+commands[nodenv] )) &>/dev/null; then
            _sukka_lazyload_command_nodenv() {
                eval "$(nodenv init - zsh)"
            }

            _sukka_lazyload_completion_nodenv() {
                source "$NODENV_ROOT/completions/nodenv.zsh"
            }

            _lazyload_add_command nodenv
            _lazyload_add_completion nodenv
        fi
      '';
    };
  };
}
