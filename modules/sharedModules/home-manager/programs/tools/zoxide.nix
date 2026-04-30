{ config, ... }:
{
  home.shellAliases = {
    j = "z";
  };

  programs = {
    zoxide = {
      enable = true;
      enableBashIntegration = config.programs.bash.enable;
      enableZshIntegration = config.programs.zsh.enable;
    };
  };
}
