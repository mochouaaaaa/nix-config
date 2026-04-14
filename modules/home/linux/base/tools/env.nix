{ config, ... }:
{

  programs.go = {
    GOPATH = "${config.home.homeDirectory}/Code/Projects/golang";
  };

}
