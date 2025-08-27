{ pkgs, ... }:
{
  programs =
    let
      goenv = ''
        export GOPATH=/Volumes/Code/Projects/golang
        export GOBIN=$GOPATH/bin
      '';

    in
    {
      zsh = {
        initContent = goenv;
        envExtra = ''
          # export PATH="/etc/profiles/per-user/$USER/bin:/run/current-system/sw/bin:$PATH"
          # export PATH=$(tr ':' '\n' <<< "$PATH" | awk '!seen[$0]++' | paste -sd ':' -)
        '';
      };

      bash = {
        initExtra = goenv;
      };
    };

  home.shellAliases = {
    projects = "cd /Volumes/Code";
  };

}
