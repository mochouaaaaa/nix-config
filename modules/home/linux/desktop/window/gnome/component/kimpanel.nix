{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules'.desktop.gnome.shell.packages.kimpanel;
in
{

  options.modules'.desktop.gnome.shell.packages.kimpanel = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable unite gnome shell extension.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.gnome-shell = {
      extensions = [
        { package = pkgs.gnomeExtensions.kimpanel; }
      ];
    };
  };
}
