{
  programs.zsh = {
    dirHashes = {
      projects = "$HOME/Code";
    };
    initContent = ''
      export GOPATH=$HOME/Code/Projects/golang
      export GOBIN=$GOPATH/bin
    '';
  };
}
