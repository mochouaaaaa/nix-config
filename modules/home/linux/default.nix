{ self, lib, ... }:
{
  imports = lib.importModule' ./.;
}
