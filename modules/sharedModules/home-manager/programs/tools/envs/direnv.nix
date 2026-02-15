{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    (writeShellScriptBin "nixify" ''
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
        ''${EDITOR:-nvim} default.nix
      fi
    '')
    (writeShellScriptBin "flakify" ''
      if [ ! -e flake.nix ]; then
        nix flake new -t github:nix-community/nix-direnv .
      elif [ ! -e .envrc ]; then
        echo "use flake" > .envrc
        direnv allow
      fi
      ''${EDITOR:-nvim} flake.nix
    '')
    (writeShellScriptBin "direnv-clean" ''
      pwd=$(pwd)
      rm -rf $pwd/{.envrc,.direnv,default.nix,flake.*}
      echo -e "\033[93m All direnv related files have been removed. \033[0m"
    '')
  ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;

      enableZshIntegration = config.programs.zsh.enable;
      enableBashIntegration = config.programs.bash.enable;
    };
  };
}
