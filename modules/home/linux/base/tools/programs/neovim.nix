{ lib, ... }:
{
  modules.xdg-mime.editors = lib.mkAfter [
    "nvim.desktop"
  ];
}
