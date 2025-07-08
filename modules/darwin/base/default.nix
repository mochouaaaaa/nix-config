{ lib, self, ... }:
{
  imports = (lib.importModule' ./.) ++ [
    ../tools
  ];
}
