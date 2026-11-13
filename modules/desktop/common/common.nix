{ self, ... }:
{
  flake.modules.homeManager."desktop.common" = {
    imports = [
      self.modules.homeManager.rime
      self.modules.homeManager.appearance
      self.modules.homeManager.shortcuts
      self.modules.homeManager."desktop.launcher.vicinae"
    ];
  };

  flake.modules.nixos."desktop.common" =
    {
      self,
      pkgs,
      username,
      ...
    }:
    {
      imports = [
        self.modules.nixos.appearance
        self.modules.nixos.hardware
        self.modules.nixos."hardware.audio"
        self.modules.nixos."hardware.bluetooth"
        self.modules.nixos."security.desktop"
      ];

      services.geoclue2.enable = true;

      environment.systemPackages = [ pkgs.uwsm ];

      # Enable the system portal service; Home Manager supplies the user's
      # compositor-specific portal configuration and backend packages.
      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };

      home-manager.users.${username}.imports = [
        self.modules.homeManager."desktop.common"
      ];
    };
}
