{
  self,
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.modules'.desktop.component.status-bar.waybar;
in
{
  imports = lib.importModule' ./.;

  config = lib.mkIf cfg.enable {

    programs.waybar = {
      enable = true;
      package = pkgs.waybar_git;
      systemd = {
        enable = true;
      };
    };

  };
}
