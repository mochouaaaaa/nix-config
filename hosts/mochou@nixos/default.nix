{
  lib,
  pkgs,
  self,
  username,
  hostName,
  system,
  ...
}:

{
  profiles.preservation.enable = true;
  profiles.services.proxy.enable = true;

  # Keep VM builds in text mode while preserving the normal host desktop.
  virtualisation.vmVariant = {
    imports = [ self.modules.nixos.appearance ];
    # VM Nix stores are mounted read-only, so Home Manager packages must be
    # installed through users.users.<name>.packages rather than nix profile.
    home-manager.useUserPackages = lib.mkForce true;
    virtualisation.forwardPorts = [
      {
        from = "host";
        host.address = "127.0.0.1";
        host.port = 2223;
        guest.port = 22;
      }
    ];
    programs.hyprland.enable = lib.mkForce false;
    services.xserver.enable = lib.mkForce false;
    services.displayManager.noctalia-greeter.enable = lib.mkForce false;
    environment.systemPackages = [ pkgs.bat ];
    fonts.packages = with pkgs; [
      noto-fonts-cjk-sans
      source-han-sans
      source-han-serif
    ];
    environment.etc."mosdns-vm.env".text = ''
      DNS_ID=vm-test
      DNS_V41=45.90.28.0
      DNS_V61=2a07:a8c0::
      DNS_V42=45.90.30.0
    '';
    environment.etc."mihomo-vm.env".text = ''
      subscription=https://example.invalid/subscription.yaml
    '';
    systemd.services.mosdns.serviceConfig.EnvironmentFile = lib.mkForce "/etc/mosdns-vm.env";
    systemd.services.mihomo-config.serviceConfig.EnvironmentFile = lib.mkForce "/etc/mihomo-vm.env";
  };

  imports = [
    self.modules.nixos.preservation
    self.modules.nixos."desktop.hyprland"
    self.modules.nixos."desktop.flatpak"
    self.modules.nixos."desktop.programs.database"
    self.modules.nixos."desktop.programs.networking"
    self.modules.nixos.boot-loader-limine
    self.modules.nixos."hardware.hid-apple"
    self.modules.nixos."profiles.zram"
    # self.modules.nixos."desktop.niri"

    self.modules.nixos."services.dns"
    self.modules.nixos."services.avahi"
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
        self.modules.homeManager.workstation
        self.modules.homeManager.linux
        self.modules.homeManager."development.gui"
        self.modules.homeManager."agents.codex"
        self.modules.homeManager."agents.antigravity"
        self.modules.homeManager."desktop.programs.audio"
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
