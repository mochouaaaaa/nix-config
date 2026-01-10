{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  cfg = config.profiles.desktop.niri;
in
{
  imports = [ inputs.niri.homeModules.niri ];

  config = lib.mkIf cfg.enable {

    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };

  };
}
