{ lib, ... }:
{
  # imports = lib.importModule' ./.;
  imports = [ ./vicinae.nix ];
}
