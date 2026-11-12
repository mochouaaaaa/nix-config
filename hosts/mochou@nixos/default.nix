{
  self,
  username,
  hostName,
  system,
  ...
}:

{
  profiles.preservation.enable = true;

  imports = [
    self.modules.nixos.preservation
    self.modules.nixos."desktop.hyprland"
    # self.modules.nixos."desktop.niri"

    self.modules.nixos."services.proxy"
    self.modules.nixos."services.mysql"
    self.modules.nixos."services.redis"
    self.modules.nixos."services.postgresql"
  ];

  networking.hostName = hostName;
  nixpkgs.hostPlatform = system;

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
        self.modules.homeManager.programs
        self.modules.homeManager.linux
      ];
    };
  };
}
