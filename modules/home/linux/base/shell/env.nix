{ config, ... }:
{
  programs = {
    zsh = {
      dirHashes = {
        projects = "$HOME/Code";
      };
    };
  };

  programs.go = {
    GOPATH = "${config.home.homeDirectory}/Code/Projects/golang";
  };

}
