{ config, ... }:
{
  programs = {
    eza = {
      enable = true;
      enableBashIntegration = config.programs.bash.enable;
      enableZshIntegration = config.programs.zsh.enable;
      git = true;
      icons = "auto";
      colors = "auto";
      extraOptions = [ ];
    };
  };
}
