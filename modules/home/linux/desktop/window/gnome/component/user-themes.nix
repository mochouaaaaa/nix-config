{ lib, pkgs, ... }:
{
  programs.gnome-shell = {
    extensions = lib.mkAfter [
      { package = pkgs.gnomeExtensions.user-themes; }
    ];
  };
}
