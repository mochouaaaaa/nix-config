{
  flake.aspects."programs"."homeManager" =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {

      xdg.configFile =
        let
          catppuccinTheme = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "6810349b28055dce54076712fc05fc68da4b8ec0";
            sha256 = "sha256-lJapSgRVENTrbmpVyn+UQabC9fpV1G1e+CdlJ090uvg=";
          };
        in
        {
          "bat/themes" = {
            recursive = true;
            source = "${catppuccinTheme}/themes";
          };
        };

      home = {
        shellAliases =
          let
            cat = pkgs.writeShellApplication {
              name = "cat";
              runtimeInputs = [
                pkgs.bat
                pkgs.kitty
              ];

              text = ''
                if [[ $# -eq 0 ]]; then
                  bat -p --style=plain
                  exit
                fi

                status=0

                for file in "$@"; do
                  case "$file" in
                    *.png|*.jpg|*.jpeg|*.gif|*.webp|*.bmp|*.tiff|*.avif)
                      kitten icat "$file" || status=$?
                      ;;
                    *)
                      bat -p --style=plain "$file" || status=$?
                      ;;
                  esac
                done

                exit "$status"
              '';
            };
          in
          {
            cat = "${lib.getExe cat}";
          };
        sessionVariables = lib.mkIf config.xdg.configFile."bat/themes".enable {
          BAT_THEME_DARK = "Catppuccin Mocha";
          BAT_THEME_LIGHT = "Catppuccin Latte";
        };
      };

      programs = {
        zsh = {
          initContent =
            let
              bathelp = "bat --style=plain --language=help";
            in
            ''
              help() {
                  "$@" --help 2>&1 | ${bathelp}
              }
              alias -g -- -h='-h 2>&1 | ${bathelp}'
              alias -g -- --help='--help 2>&1 | ${bathelp}'
            '';
        };
        bat = {
          enable = true;
          extraPackages = with pkgs.bat-extras; [
            batdiff
            batman
            batgrep
            batwatch
          ];
          config = {
            pager = "less -FRX";
          };
          syntaxes = {
            gleam = {
              src = pkgs.fetchFromGitHub {
                owner = "molnarmark";
                repo = "sublime-gleam";
                rev = "2e761cdb1a87539d827987f997a20a35efd68aa9";
                hash = "sha256-Zj2DKTcO1t9g18qsNKtpHKElbRSc9nBRE2QBzRn9+qs=";
              };
              file = "syntax/gleam.sublime-syntax";
            };
          };
        };
      };

    };
}
