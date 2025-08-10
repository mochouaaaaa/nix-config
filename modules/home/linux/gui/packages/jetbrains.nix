{
  pkgs,
  lib,
  config,
  username,
  nvfetcherSources,
  ...
}:
let
  cfg = config.modules'.packages.jetbrains;
  jetbrainsConfig = enable: {
    pycharm = enable && cfg.pycharm.enable;
    goland = enable && cfg.goland.enable;
    datagrip = enable && cfg.datagrip.enable;
    clion = enable && cfg.clion.enable;
  };

  initjetbrains = jetbrainsConfig cfg.enable;

in
{
  options.modules'.packages.jetbrains = {
    enable = lib.mkEnableOption "JetBrains IDEs";
    pycharm = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = (
          pkgs.pycharm {
            inherit username;
            src = nvfetcherSources.pycharm.src;
          }
        );
      };
    };
    goland = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = (
          pkgs.goland {
            inherit username;
            src = nvfetcherSources.goland.src;
          }
        );
      };
    };
    datagrip = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = (
          pkgs.datagrip {
            inherit username;
            src = nvfetcherSources.datagrip.src;
          }
        );
      };
    };
    clion = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = (
          pkgs.clion {
            inherit username;
            src = nvfetcherSources.clion.src;
          }
        );
      };
    };
  };

  config = {
    home.packages = lib.mkMerge [
      (lib.mkIf initjetbrains.pycharm [ cfg.pycharm.package ])
      (lib.mkIf initjetbrains.goland [ cfg.goland.package ])
      (lib.mkIf initjetbrains.datagrip [ cfg.datagrip.package ])
      (lib.mkIf initjetbrains.clion [ cfg.clion.package ])
    ];
  };
}
