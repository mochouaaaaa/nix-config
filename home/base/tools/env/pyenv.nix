{pkgs, ...}: let
  pyenv-virtualenv = pkgs.fetchgit {
    url = "https://github.com/pyenv/pyenv-virtualenv.git";
    hash = "sha256-enINH1AWCVAnBR9M/uQ7eCDfNzgYgBUVV7N/ZCf3CVI=";
  };
  pyenv-virtualenvwrapper = pkgs.fetchgit {
    url = "https://github.com/pyenv/pyenv-virtualenvwrapper.git";
    hash = "sha256-vvkJf2dRJySLQCkBzBUc86D2zg921wCbxFe3Nq/EnOc=";
  };
  pyenv-pip-migrate = pkgs.fetchgit {
    url = "https://github.com/pyenv/pyenv-pip-migrate.git";
    hash = "sha256-TLc5KfvbMW5ziMyysOoqqTlYOMgkNzMvdfMP7ZY8CwU=";
  };
  pyenv-doctor = pkgs.fetchgit {
    url = "https://github.com/pyenv/pyenv-doctor.git";
    hash = "sha256-U4nfLBUTi+VaalQqtC/iB3wZgYiNwwZd19aKltI/Maw=";
  };
in {
  xdg.configFile = {
    "env/pyenv" = {
      source = pkgs.pyenv;
      recursive = true;
      force = true;
    };
    "env/pyenv/plugins/pyenv-virtualenv" = {
      source = pyenv-virtualenv;
      recursive = true;
      force = true;
    };
    "env/pyenv/plugins/pyenv-virtualenvwrapper" = {
      source = pyenv-virtualenvwrapper;
      recursive = true;
      force = true;
    };
    "env/pyenv/plugins/pyenv-pip-migrate" = {
      source = pyenv-pip-migrate;
      recursive = true;
      force = true;
    };
    "env/pyenv/plugins/pyenv-doctor" = {
      source = pyenv-doctor;
      recursive = true;
      force = true;
    };
  };
  home.file = {
    #  FIX: will cause errors in other xdg.configFiles in the same directory
    ".config/zsh/plugins/pyenv.zsh" = {
      text = ''
        export PYENV_ROOT="$HOME/.config/env/pyenv"
        export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"

        source $HOME/.config/zsh/plugins/lazyZsh.zsh

        if (( $+commands[pyenv] )) &>/dev/null; then
            _sukka_lazyload_command_pyenv() {
                eval "$(command pyenv init -)"
                eval "$(command pyenv virtualenv-init -)"
            }
            _lazyload_add_command pyenv

            _sukka_lazyload_completion_pyenv() {
                source "''${PYENV_ROOT}/completions/pyenv.zsh"
            }
            _lazyload_add_completion pyenv
        fi
      '';
    };
  };
}
