{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfgGnome = config.modules'.desktop.gnome;
in
{
  config = lib.mkIf cfgGnome.enable {

    programs.gnome-shell = {
      extensions = lib.mkAfter [
        { package = pkgs.gnomeExtensions.fuzzy-app-search; }
      ];
    };

  };
}
