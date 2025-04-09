{ pkgs, ... }:
{
  programs.zsh = {
    initExtra = ''
      export GOPATH=/Volumes/Code/Projects/golang
      hash -d projects="/Volumes/Code"
    '';
    envExtra = ''
      # export PATH="/etc/profiles/per-user/$USER/bin:/run/current-system/sw/bin:$PATH"
      # export PATH=$(tr ':' '\n' <<< "$PATH" | awk '!seen[$0]++' | paste -sd ':' -)
    '';
  };
}
