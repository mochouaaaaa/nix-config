{
  self,
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.modules.desktop.component.waybar;
in
{
  imports = lib.importModule' ./.;

  options.modules.desktop.component.waybar = {
    enable = lib.mkEnableOption "Waybar status bar" // {
      default = false;
    };
  };

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
