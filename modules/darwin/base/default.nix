{ lib, self, ... }:
{
  imports = (lib.importModule' ./.) ++ [
    ../programs
  ];
}
