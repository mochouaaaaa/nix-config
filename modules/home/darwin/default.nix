{ lib, self, ... }:
{
  imports = lib.importModule' ./.;
}
