{
  pkgs,
  config,
  lib,
  ...
}:
let
  catppuccinMochaTheme = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "btop";
    rev = "89ff712";
    sha256 = "sha256-J3UezOQMDdxpflGax0rGBF/XMiKqdqZXuX4KMVGTxFk=";
  };

  cfg = config.modules.packages.btop;
in
{
  options.modules.packages.btop = {
    enable = lib.mkEnableOption "btop";
  };

  config = lib.mkIf cfg.enable {

    programs = {
      zsh.shellAliases = {
        # top = "btop";
      };
      btop = {
        enable = true;
        package = pkgs.btop;
        settings = {
          color_theme = "catppuccin_mocha";
        };
      };
    };
    xdg.configFile."btop/themes".source = catppuccinMochaTheme + "/themes";

  };
}
