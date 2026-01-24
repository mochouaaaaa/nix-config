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

  cfg = config.profiles.packages.btop;
in
{
  options.profiles.packages.btop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {

    programs = {
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
