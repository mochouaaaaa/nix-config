{ lib, pkgs, ... }:
{
  programs.gnome-shell = {
    extensions = lib.mkAfter [
      { package = pkgs.gnomeExtensions.fuzzy-app-search; }
    ];
  };
}
