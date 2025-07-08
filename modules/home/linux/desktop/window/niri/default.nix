{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  cfg = config.modules.desktop.niri;
in
{
  imports = lib.importModule' ./. ++ [ inputs.niri.homeModules.niri ];

  options.modules.desktop.niri = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = builtins.getEnv "DESKTOP" == "niri";
      description = "Enable Niri window manager";
    };
  };

  config = lib.mkIf cfg.enable {

    programs.niri = {
      enable = true;
      package = pkgs.niri;
    };

  };
}
