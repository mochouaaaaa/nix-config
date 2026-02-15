{ config, ... }:
{
  home.shellAliases = {
    j = "z";
  };

  programs = {
    zoxide = {
      enableBashIntegration = config.programs.bash.enable;
      enableZshIntegration = config.programs.zsh.enable;
    };
  };
}
