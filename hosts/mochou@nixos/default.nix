{
  self,
  username,
  hostName,
  system,
  ...
}:

{
  profiles.preservation.enable = true;
  profiles.services.proxy.enable = true;

  imports = [
    self.modules.nixos.preservation
    self.modules.nixos."desktop.hyprland"
    self.modules.nixos."programs.flatpak"
    self.modules.nixos."programs.db-clients"
    self.modules.nixos.boot-loader-limine
    self.modules.nixos."hardware.hid-apple"
    self.modules.nixos."profiles.zram"
    # self.modules.nixos."desktop.niri"

    self.modules.nixos."services.dns"
    self.modules.nixos."services.console"
    self.modules.nixos."services.brightness"
    self.modules.nixos."services.uptermd"
    self.modules.nixos."services.proxy"
    self.modules.nixos."programs.evolution"
    self.modules.nixos."services.ollama"
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
        self.modules.homeManager.host
        self.modules.homeManager.linux
        self.modules.homeManager."programs.codex"
        self.modules.homeManager."desktop.programs.audio"
        self.modules.homeManager."desktop.programs.browsers"
        self.modules.homeManager."desktop.programs.security"
        self.modules.homeManager."desktop.programs.communication"
        self.modules.homeManager."desktop.programs.email"
        self.modules.homeManager."desktop.programs.media"
        self.modules.homeManager."desktop.programs.notes"
        self.modules.homeManager."desktop.programs.remote"
        self.modules.homeManager."desktop.programs.office"
      ];
    };
  };
}
