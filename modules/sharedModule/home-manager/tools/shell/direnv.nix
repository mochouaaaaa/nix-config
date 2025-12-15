{ lib, pkgs, ... }:
{
  home.packages = [
    pkgs.devenv
  ];

  programs =
    let
      direnv_shell_warpper = ''
        nixify() {
          if [ ! -e ./.envrc ]; then
            echo "use nix" > .envrc
            direnv allow
          fi
          if [[ ! -e shell.nix ]] && [[ ! -e default.nix ]]; then
            cat > default.nix <<'EOF'
        with import <nixpkgs> {};
        mkShell {
          nativeBuildInputs = [
            bashInteractive
          ];
        }
        EOF
            ''${"EDITOR:-vim"} default.nix
          fi
        }
        flakify() {
          if [ ! -e flake.nix ]; then
            nix flake new -t github:nix-community/nix-direnv .
          elif [ ! -e .envrc ]; then
            echo "use flake" > .envrc
            direnv allow
          fi
          ''${"EDITOR:-vim"} flake.nix
        }
      '';
    in
    rec {
      direnv = {
        enable = true;
        nix-direnv.enable = true;

        enableZshIntegration = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
      };

      zsh = {
        initContent = lib.optionalString (direnv.enable) direnv_shell_warpper;
        plugins = [
          {
            name = "just";
            src = pkgs.just;
            file = "share/zsh/site-functions/_just";
          }
        ];
      };
      bash.initExtra = direnv_shell_warpper;
    };
}
