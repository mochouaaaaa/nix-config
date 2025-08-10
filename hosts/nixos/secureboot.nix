{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  # imports = [
  #   inputs.lanzaboote.nixosModules.lanzaboote
  # ];
  #
  # environment.systemPackages = [
  #   # For debugging and troubleshooting Secure Boot.
  #   pkgs.sbctl
  # ];
  #
  # boot.loader.systemd-boot.enable = lib.mkForce false;
  #
  # boot.lanzaboote = {
  #   enable = true;
  #   pkiBundle = "/var/lib/sbctl";
  # };
}
