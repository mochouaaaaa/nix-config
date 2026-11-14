{
  flake.modules.homeManager."cli.direnv" =
    {
      pkgs,
      config,
      ...
    }:
    {
      home.packages = with pkgs; [
        (writeShellApplication {
          name = "nixify";
          runtimeInputs = [ direnv ];
          text = ''
            if [ ! -e ./.envrc ]; then
              echo "use nix" > .envrc
              direnv allow
            fi
            if [[ ! -e shell.nix ]] && [[ ! -e default.nix ]]; then
              cat > default.nix <<'EOF'
            with import <nixpkgs> {};
            mkShell { nativeBuildInputs = [ bashInteractive ]; }
            EOF
              ''${EDITOR:-nvim} default.nix
            fi
          '';
        })
        (writeShellApplication {
          name = "flakify";
          runtimeInputs = [ direnv ];
          text = ''
            if [ ! -e flake.nix ]; then
              nix flake new -t github:nix-community/nix-direnv .
            elif [ ! -e .envrc ]; then
              echo "use flake" > .envrc
              direnv allow
            fi
            ''${EDITOR:-nvim} flake.nix
          '';
        })
        (writeShellApplication {
          name = "direnv-clean";
          runtimeInputs = [ coreutils ];
          text = ''
            rm -rf -- .envrc .direnv default.nix flake.nix flake.lock
            echo "All direnv-related files have been removed."
          '';
        })
      ];

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        enableZshIntegration = config.programs.zsh.enable;
        enableBashIntegration = config.programs.bash.enable;
      };
    };

  flake.modules.nixos.preservation =
    {
      lib,
      config,
      username,
      ...
    }:
    {
      profiles.preservation.users.${username}.directories =
        lib.optionals config.home-manager.users.${username}.programs.direnv.enable
          [ ".local/share/direnv" ];
    };
}
