{pkgs, ...}: {
  programs = {
    bat = {
      enable = true;
      package = pkgs.bat;
      extraPackages = with pkgs.bat-extras; [batdiff batman batgrep batwatch];
      themes = {
        catppuccin-mocha = let
          catppuccinMochaTheme = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "699f60fc8ec434574ca7451b444b880430319941";
            sha256 = "sha256-6fWoCH90IGumAMc4buLRWL0N61op+AuMNN9CAR9/OdI=";
          };
        in {
          src = catppuccinMochaTheme + "/themes";
          file = "Catppuccin Mocha.tmTheme";
        };
      };
      config = {
        theme = "catppuccin-mocha";
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
