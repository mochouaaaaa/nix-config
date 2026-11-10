{
  self,
  username,
  platform,
  ...
}:

{
  profiles.preservation.enable = true;

  imports = [
    self.modules.nixos.preservation
    self.modules.nixos."desktop.hyprland"

    # Host services are intentionally independent of the desktop environment.
    self.modules.nixos."services.proxy"
    self.modules.nixos."services.mysql"
    self.modules.nixos."services.redis"
    self.modules.nixos."services.postgresql"

  ];

  networking.hostName = platform;
  nixpkgs.hostPlatform = "x86_64-linux";

  profiles.hardware.kvm = {
    enable = true;
    cpuVendor = "amd";
    ignoreMsrs = true;
  };

  home-manager = {
    sharedModules = [
      {
        age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIECNEOhSUgaHrFy8WYaHcFTTyeBDaS2bNXj/mE7RCkGo";
      }
    ];
    users.${username} = {
      imports = [
        self.modules.homeManager.agenix
        self.modules.homeManager.core
        self.modules.homeManager.linux
        self.modules.homeManager.programs
        self.modules.homeManager.development
      ];
    };
  };

}
