{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.packages.envs.luaenv;

  luaenv = pkgs.fetchgit {
    url = "https://github.com/cehoffman/luaenv.git";
    hash = "sha256-m/ijHWsEwkyJpRnFaWx+mlVCNXIDGmikfS7r9hh2LVw=";
  };
  lua-build = pkgs.fetchgit {
    url = "https://github.com/cehoffman/lua-build.git";
    hash = "sha256-81arYsCftWCHxOJdl3wfvmakg6tPRKlq4KJ/RQG3aUM=";
  };
  luaenv-luarocks = pkgs.fetchgit {
    url = "https://github.com/xpol/luaenv-luarocks.git";
    hash = "sha256-3Y49MI8cyzgOo0REhi7LWfgcK/ffS50jvJRzG/1Jddw=";
  };
in
{
  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "env/luaenv" = {
        source = luaenv;
        recursive = true;
        force = true;
      };
      "env/luaenv/plugins/lua-build" = {
        source = lua-build;
        recursive = true;
        force = true;
      };
      "env/luaenv/plugins/luaenv-luarocks" = {
        source = luaenv-luarocks;
        recursive = true;
        force = true;
      };
    };
    programs.zsh.initExtra = ''
      export LUAENV_ROOT="$HOME/.config/env/luaenv"
      export PATH="$LUAENV_ROOT/bin:$LUAENV_ROOT/shims:$PATH"

      source $HOME/.config/zsh/plugins/lazyZsh.zsh

      if (( $+commands[luaenv] )) &>/dev/null; then
          _sukka_lazyload_command_luaenv() {
              eval "$(luaenv init -)"
          }

          _sukka_lazyload_completion_luaenv (){
              source "$LUAENV_ROOT/completions/luaenv.zsh"
          }

          _lazyload_add_command luaenv
          _lazyload_add_completion luaenv
      fi
    '';
  };
}
