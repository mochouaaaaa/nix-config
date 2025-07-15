{ config, lib, ... }:
let
  cfg = config.modules.desktop.component.status-bar;
in
{

  options.modules.desktop.component.status-bar = {
    waybar = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable waybar status bar";
      };
    };
    ashell = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable ashell status bar";
      };
    };
    ags = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable ags status bar";
      };
    };
  };

  imports = lib.importModule' ./.;

  config = lib.mkIf (cfg.waybar.enable || cfg.ashell.enable || cfg.ags.enable) {

  };

}
