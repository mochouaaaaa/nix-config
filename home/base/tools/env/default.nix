{
  lib,
  myvars,
  ...
}: let
  pyenv = ./pyenv.nix;
  goenv = ./goenv.nix;
  nodenv = ./nodenv.nix;
  luaenv = ./luaenv.nix;

  pyenvEnable = myvars.envs.pyenv;
  goenvEnable = myvars.envs.goenv;
  nodenvEnable = myvars.envs.nodenv;
  luaenvEnable = myvars.envs.luaenv;

  lazyZsh = pyenvEnable || goenvEnable || nodenvEnable || luaenvEnable;
in {
  imports =
    [
      ./pip.nix
    ]
    ++ (lib.optionals pyenvEnable [pyenv])
    ++ (lib.optionals goenvEnable [goenv])
    ++ (lib.optionals nodenvEnable [nodenv])
    ++ (lib.optionals luaenvEnable [luaenv]);

  config = lib.mkIf lazyZsh {
    xdg.configFile."zsh/plugins/lazyZsh.zsh" = {
      text = ''
        _lazyload_add_command() {
            eval "$1() {
                unfunction $1;
                _sukka_lazyload_command_$1;
                $1 $@;
            }"
        }

        _lazyload_add_completion() {
            local comp_name="_sukka_lazyload__compfunc_$1"
            eval "''${comp_name}() {
                compdef -d $1;
                _sukka_lazyload_completion_$1;
            }"
            compdef $comp_name $1
        }
      '';
    };
  };
}
