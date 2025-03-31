{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.packages.envs.nodenv;

  nodenv-build = pkgs.fetchgit {
    url = "https://github.com/nodenv/node-build.git";
    hash = "sha256-jBk6U0F69mcAVYQDn7uxhc0Y+3i60ACD8K4pskewVXQ=";
  };
  nodenv-vars = pkgs.fetchgit {
    url = "https://github.com/nodenv/nodenv-vars.git";
    hash = "sha256-o9lc21DmRvhDKPX14Fpo2tg8csNy+qvDJZPGd4pe3VM=";
  };
  nodenv-aliases = pkgs.fetchgit {
    url = "https://github.com/nodenv/nodenv-aliases.git";
    hash = "sha256-OxjEgY7tz8c2d9gm7Dle36EeEBPx2QS0bDctAExRcyA=";
  };
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [yarn];

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
      "env/nodenv/plugins/nodoenv-vars" = {
        source = nodenv-vars;
        recursive = true;
        force = true;
      };
      "env/nodenv/plugins/nodenv-aliases" = {
        source = nodenv-aliases;
        recursive = true;
        force = true;
      };
      "${config.dotfiles}/zsh/plugins/nodenv.zsh" = {
        text = ''
          export NODENV_ROOT="$HOME/.config/env/nodenv"
          export PATH="$NODENV_ROOT/bin:$NODENV_ROOT/shims:$PATH"

          source $HOME/.config/zsh/plugins/lazyZsh.zsh

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
  };
}
