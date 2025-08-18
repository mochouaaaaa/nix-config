{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.packages.obsidian;
in
{

  options.modules'.packages.obsidian = with lib; {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable Obsidian.";
    };
  };

  config = lib.mkIf cfg.enable {

    programs.obsidian = {
      enable = true;
      package = pkgs.obsidian-wrapper;
      defaultSettings = {
        themes = [ "Catppuccin" ];
      };
    };

  };
}
