{ system, hostName, username, ... }:
{
  networking.hostName = hostName;
  nixpkgs.hostPlatform = system;

  # Keep the WSL login user aligned with the account declared by nixos.core.
  wsl.defaultUser = username;
}
