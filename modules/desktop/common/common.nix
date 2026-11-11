{ self, ... }:
{
  flake.modules.homeManager."desktop.common" = {
    imports = [
      self.modules.homeManager.rime
      self.modules.homeManager.appearance
      self.modules.homeManager.shortcuts
      self.modules.homeManager."desktop.launcher.vicinae"
      self.modules.homeManager."desktop.programs"
    ];
  };

  flake.modules.nixos."desktop.common" = { self, username, ... }: {
    imports = [
      self.modules.nixos.appearance
      self.modules.nixos.hardware
      self.modules.nixos."hardware.audio"
      self.modules.nixos."hardware.bluetooth"
    ];

    services.geoclue2.enable = true;

    home-manager.users.${username}.imports = [
      self.modules.homeManager."desktop.common"
    ];
  };
}
