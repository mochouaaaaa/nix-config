{
  pkgs,
  lib,
  config,
  nvfetcherSources,
  ...
}:
let
  cfg = config.modules.packages.jetbrains;
  jetbrainsConfig = enable: {
    pycharm = enable && cfg.pycharm.enable;
    goland = enable && cfg.goland.enable;
    datagrip = enable && cfg.datagrip.enable;
    clion = enable && cfg.clion.enable;
  };

  initjetbrains = jetbrainsConfig cfg.enable;

in
{
  options.modules.packages.jetbrains = {
    enable = lib.mkEnableOption "JetBrains IDEs";
    pycharm = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = (
          pkgs.pycharm.overrideAttrs {
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
        default = pkgs.goland.overrideAttrs {
          src = nvfetcherSources.goland.src;
        };
      };
    };
    datagrip = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.datagrip.overrideAttrs {
          src = nvfetcherSources.datagrip.src;
        };
      };
    };
    clion = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.clion.overrideAttrs {
          src = nvfetcherSources.clion.src;
        };
      };
    };
  };

  config = {
    home.packages =
      [
      ]
      ++ (lib.optionals (initjetbrains.pycharm) [
        cfg.pycharm.package
      ])
      ++ (lib.optionals (initjetbrains.goland) [
        cfg.goland.package
      ])
      ++ (lib.optionals (initjetbrains.datagrip) [
        cfg.datagrip.package
      ])
      ++ (lib.optionals (initjetbrains.clion) [
        cfg.clion.package
      ]);
  };
}
