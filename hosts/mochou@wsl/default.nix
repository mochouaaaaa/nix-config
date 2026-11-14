{
  self,
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

  home-manager = {
    sharedModules = [
      {
        age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGZ/55qfEl93PzcMW3rGAAtClPYFloVkMpwvxVUr6Xyu";
      }
    ];
  };

  home-manager.users.${username} = {
    imports = [
      self.modules.homeManager.host
      self.modules.homeManager.linux
      self.modules.homeManager.wsl
      self.modules.homeManager.servers
    ];
  };
}
