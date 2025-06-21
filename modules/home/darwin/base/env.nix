{ pkgs, ... }:
{
  programs =
    let
      goenv = ''
        export GOPATH=/Volumes/Code/Projects/golang
        export GOBIN=$GOPATH/bin
      '';

      dirHashes = {
        projects = "/Volumes/Code";
      };

    in
    {
      zsh = {
        dirHashes = dirHashes;
        initContent = goenv;
        envExtra = ''
          # export PATH="/etc/profiles/per-user/$USER/bin:/run/current-system/sw/bin:$PATH"
          # export PATH=$(tr ':' '\n' <<< "$PATH" | awk '!seen[$0]++' | paste -sd ':' -)
        '';
      };
      bash = {
        initExtra = goenv;
        shellAliases = {
          projects = "cd " + dirHashes.projects;
        };
      };
    };
}
