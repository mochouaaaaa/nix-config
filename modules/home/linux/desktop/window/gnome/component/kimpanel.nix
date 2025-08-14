{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules'.desktop.gnome.shell.packages.unite;
in

{
  config = lib.mkIf cfg.enable {
    programs.gnome-shell = {
      extensions = [
        { package = pkgs.gnomeExtensions.kimpanel; }
      ];
    };
  };
}
