{ pkgs, ... }:
{
  programs.zsh = {
    dirHashes = {
      projects = "/Volumes/Code";
    };
    initExtra = ''
      export GOPATH=/Volumes/Code/Projects/golang
      export GOBIN=$GOPATH/bin
    '';
    envExtra = ''
      # export PATH="/etc/profiles/per-user/$USER/bin:/run/current-system/sw/bin:$PATH"
      # export PATH=$(tr ':' '\n' <<< "$PATH" | awk '!seen[$0]++' | paste -sd ':' -)
    '';
  };
}
