{ system, hostName, ... }:
{

  networking.hostName = hostName;
  nixpkgs.hostPlatform = system;
}
