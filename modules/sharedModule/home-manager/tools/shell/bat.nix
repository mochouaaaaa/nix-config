{ pkgs, ... }:
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

  programs = {
    zsh = {
      shellAliases = {
        cat = "bat -p --style=plain";
      };
      initContent = ''
        alias bathelp="bat --plain --language=help";

        help() {
            "$@" --help 2>&1 | bathelp
        }
        alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
        alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

        BAT_THEME_DARK="Catppuccin Mocha"
        BAT_THEME_LIGHT="Catppuccin Latte"
      '';
    };
    bat = {
      enable = true;
      package = pkgs.bat;
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
}
