{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules'.packages.envs.nodenv;

  nodenv-build = pkgs.fetchFromGitHub {
    owner = "nodenv";
    repo = "node-build";
    rev = "v5.4.9";
    hash = "sha256-/smT+44qrgMpzeCOO8erMhYDpA0rkCRFiRnQjUy35BM=";
  };
  nodenv-aliases = pkgs.fetchFromGitHub {
    owner = "nodenv";
    repo = "nodenv-aliases";
    rev = "v2.1.1";
    hash = "sha256-Zaze/cAlBe1CTNRNiC4sbKteBBySh7MZphpHC8mo2E4=";
  };
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ yarn ];

    xdg.configFile = lib.mkIf cfg.enable {
      "env/nodenv" = {
        source = pkgs.nodenv;
        recursive = true;
        force = true;
      };
      "env/nodenv/plugins/node-build" = {
        source = nodenv-build;
        recursive = true;
        force = true;
      };
      "env/nodenv/plugins/nodenv-aliases" = {
        source = nodenv-aliases;
        recursive = true;
        force = true;
      };
    };
    programs.zsh.initContent = lib.mkOrder 2150 ''
      export NODENV_ROOT="$HOME/.config/env/nodenv"
      export PATH="$NODENV_ROOT/bin:$NODENV_ROOT/shims:$PATH"

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
}
