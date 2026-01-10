{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.packages.obsidian;
in
{

  options.profiles.packages.obsidian = with lib; {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable Obsidian.";
    };
  };

  config = lib.mkIf (cfg.enable && config.profiles.desktop.enable) {

    programs.obsidian = {
      enable = true;
      package = pkgs.obsidian-wrapper;
      defaultSettings = {
        themes = [ "Catppuccin" ];
      };
    };

  };
}
