{
  self,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.packages.envs;

  pyenvEnable = cfg.pyenv.enable;
  goenvEnable = cfg.goenv.enable;
  nodenvEnable = cfg.nodenv.enable;
  luaenvEnable = cfg.luaenv.enable;

  lazyZsh = pyenvEnable || goenvEnable || nodenvEnable || luaenvEnable;
in
{
  options.modules.packages.envs = {
    pyenv.enable = lib.mkEnableOption "pyenv" // {
      default = false;
    };
    goenv.enable = lib.mkEnableOption "goenv" // {
      default = false;
    };
    nodenv.enable = lib.mkEnableOption "nodenv" // {
      default = false;
    };
    luaenv.enable = lib.mkEnableOption "luaenv" // {
      default = false;
    };
  };
  imports = self.importModule'  ./.;

  config = lib.mkIf lazyZsh {
    programs.zsh.initExtraFirst = ''
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
}
