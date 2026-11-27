{
  flake.aspects = { aspects, ... }: {
    cli.provides.direnvCompat = {
      homeManager =
        { lib, options, ... }:
        let
          hasDirenvenableGitIntegration = lib.hasAttrByPath [
            "programs"
            "direnv"
            "enableGitIntegration"
          ] options;
        in
        {
          config = lib.optionalAttrs hasDirenvenableGitIntegration {
            programs.direnv.enableGitIntegration = true;
          };
        };
    };

    cli.provides.direnv = {
      includes = [
        aspects.cli._.direnvCompat
      ];

      homeManager =
        {
          pkgs,
          config,
          ...
        }:
        {
          home.packages = with pkgs; [
            (writeShellApplication {
              name = "nixify";
              runtimeInputs = [
                coreutils
              ];
              text = ''
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
              '';
            })
            (writeShellApplication {
              name = "flakify";
              runtimeInputs = [ ];
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
          ];

          programs.mise = {
            enable = false;
            enableBashIntegration = true;
            enableZshIntegration = true;
            globalConfig = {
              env = {
                MISE_NIX_ALLOW_LOCAL_FLAKES = "true";
              };
              settings = {
                all_compile = false;
              };
            };
          };

          programs.direnv = {
            enable = true;
            nix-direnv.enable = true;
            mise.enable = config.programs.mise.enable;
            enableZshIntegration = config.programs.zsh.enable;
            enableBashIntegration = config.programs.bash.enable;
          };
        };
    };

    "preservation".nixos =
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
  };
}
