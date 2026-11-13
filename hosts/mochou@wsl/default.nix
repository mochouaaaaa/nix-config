{

  system,
  hostName,
  username,
  ...
}:
{

  networking.hostName = hostName;
  nixpkgs.hostPlatform = system;

  wsl.enable = true;
  wsl.defaultUser = username;
  wsl.useWindowsDriver = true;
  wsl.startMenuLaunchers = true;
  wsl.usbip.enable = true;
  wsl.ssh-agent.enable = true;
  networking.resolvconf.enable = false;

  programs.nix-ld.enable = true;
}
