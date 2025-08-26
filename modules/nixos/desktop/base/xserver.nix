{ pkgs, lib, ... }:
{
  services.xserver = {
    enable = lib.mkDefault true;
    excludePackages = with pkgs; [
      xterm
    ];
  };
}
