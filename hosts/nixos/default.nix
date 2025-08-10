{ inputs, lib, ... }:
let
  hostName = "nixos"; # Define your hostname.
in
{

  imports = lib.importModule' ./.;

  networking = {
    inherit hostName;
    # desktop need its cli for status bar
    networkmanager.enable = true;
  };

}
