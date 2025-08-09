{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  cfg = config.modules'.desktop.niri;
in
{
  imports = lib.importModule' ./. ++ [ inputs.niri.homeModules.niri ];

  config = lib.mkIf cfg.enable {

    programs.niri = {
      enable = true;
      package = pkgs.niri;
    };

  };
}
