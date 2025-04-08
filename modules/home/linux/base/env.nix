{
  programs.zsh.initExtra = ''
    hash -d projects="$HOME/Code"

    export GOPATH=$HOME/Code/Projects/golang
  '';
}
