{
  programs.zsh = {
    dirHashes = {
      projects = "$HOME/Code";
    };
    initExtra = ''
      export GOPATH=$HOME/Code/Projects/golang
    '';
  };
}
