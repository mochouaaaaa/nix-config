{ lib, pkgs-unstable, ... }:
{
  modules'.xdg-mime.editors = lib.mkAfter [
    "nvim.desktop"
  ];
}
