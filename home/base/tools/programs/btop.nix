{pkgs, ...}: let
  catppuccinMochaTheme = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "btop";
    rev = "89ff712";
    sha256 = "sha256-J3UezOQMDdxpflGax0rGBF/XMiKqdqZXuX4KMVGTxFk=";
  };
in {
  programs = {
    btop = {
      enable = true;
      package = pkgs.btop;
      settings = {color_theme = "catppuccin_mocha";};
    };
  };
  home.file.".config/btop/themes".source = catppuccinMochaTheme + "/themes";
}
