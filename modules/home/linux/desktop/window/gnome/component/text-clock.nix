{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules'.desktop.gnome.shell.packages.text-clock;
in
{

  options.modules'.desktop.gnome.shell.packages.text-clock = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable the text-clock extension.";
    };
  };

  config = lib.mkIf cfg.enable {

    programs.gnome-shell = {
      extensions = lib.mkAfter [
        { package = pkgs.gnomeExtensions.text-clock; }
      ];
    };
  };
}
