{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules'.packages.live.wiliwili;
  isdesktop = config.programs.desktop.enable;
in
{
  options.modules'.packages.live = {
    wiliwili = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "BiliBili.";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.wiliwili.overrideAttrs (oldAttrs: {
          src = pkgs.fetchFromGitHub {
            owner = "xfangfang";
            repo = "wiliwili";
            rev = "v1.5.2";
            fetchSubmodules = true;
            hash = "sha256-lcHKbEYlOznu9WhWX7ZoOCnxr6h/AJCLbjLmc2ZZTbg=";
          };
        });
      };
    };
  };

  config = lib.mkIf (cfg.enable && isdesktop) {
    home.packages = [
      cfg.package
    ];
  };
}
