{ config, ... }:
{
  programs = {

    zsh = {
      dirHashes = {
        projects = "$HOME/Code";
      };
    };
    go = rec {
      goPath = "${config.home.homeDirectory}/Code/Projects/golang";
      goBin = "${goPath}/bin";
    };

  };

}
