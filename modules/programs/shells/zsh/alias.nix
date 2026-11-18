{
  flake.modules.homeManager.programs =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {

      home = {
        packages = [
          (pkgs.writeShellApplication {
            name = "bak";
            runtimeInputs = [ pkgs.coreutils ];

            text = ''
              if [[ $# -eq 0 ]]; then
                echo "Usage: bak <file...> [--suffix SUFFIX]" >&2
                exit 1
              fi

              suffix="$(date +%Y%m%d-%H%M%S)"
              files=()

              while [[ $# -gt 0 ]]; do
                if [[ "$1" == "--suffix" ]]; then
                  if [[ $# -lt 2 ]]; then
                    echo "Error: --suffix requires a value" >&2
                    exit 1
                  fi
                  suffix="$2"
                  shift 2
                else
                  files+=("$1")
                  shift
                fi
              done

              if [[ ''${#files[@]} -eq 0 ]]; then
                echo "Error: no files specified" >&2
                exit 1
              fi

              for file in "''${files[@]}"; do
                cp -iv -- "$file" "$file.$suffix"
              done
            '';
          })
        ];
        shellAliases = {
          du = lib.getExe pkgs.dust;
          ".." = "cd ..";

          desktop = "cd ${config.xdg.userDirs.desktop}";
          downloads = "cd ${config.xdg.userDirs.download}";
          documents = "cd ${config.xdg.userDirs.documents}";
          videos = "cd ${config.xdg.userDirs.videos}";
          music = "cd ${config.xdg.userDirs.music}";
          pictures = "cd ${config.xdg.userDirs.pictures}";
        }
        // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
          movies = "cd $HOME/Movies";
        };
      };
    };

}
