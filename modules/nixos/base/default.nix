{ lib, inputs, ... }:
{
  imports = lib.importModule' ./. ++ [
    ../desktop
  ];
}
