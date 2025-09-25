{ config, ... }:
{
  programs = {

    zsh = {
      dirHashes = {
        projects = "$HOME/Code";
      };
    };
  };

  home.sessionVariables = {
    GOPATH = "${config.home.homeDirectory}/Code/Projects/golang";
  };

}
