{ config, ... }:
{
  programs = {

    zsh = {
      dirHashes = {
        projects = "$HOME/Code";
      };
    };
    # go = rec {
    #   goPath = "Code/Projects/golang";
    #   goBin = "${goPath}/bin";
    # };

  };

  home.sessionVariables = rec {
    GOPATH = "${config.home.homeDirectory}/Code/Projects/golang";
    GOBIN = "${GOPATH}/bin";
  };

}
