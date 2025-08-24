{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules'.desktop.gnome;
in

{
  config = lib.mkIf cfg.enable {
    programs.gnome-shell = {
      extensions = lib.mkAfter [
        { package = pkgs.gnomeExtensions.xremap; }
      ];
    };
  };
}
