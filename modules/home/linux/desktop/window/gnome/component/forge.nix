{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules.desktop.gnome.shell.packages.forge;
in
{

  options.modules.desktop.gnome.shell.packages.forge = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable the Forge extension in GNOME Shell.";
    };
  };

  config = lib.mkIf cfg.enable {

    programs.gnome-shell = {
      extensions = lib.mkAfter [
        { package = pkgs.gnomeExtensions.forge; }
      ];
    };
  };
}
