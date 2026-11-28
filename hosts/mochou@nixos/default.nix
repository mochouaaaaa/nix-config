{
  self,
  hostName,
  system,
  ...
}:

{
  imports = [
    self.modules.nixos."host.${hostName}"
    self.modules.nixos.agenix
    self.modules.nixos.preservation

    self.modules.nixos."services.virtualisation.vm"
    self.modules.nixos."desktop.niri"
    self.modules.nixos."desktop.flatpak"
    self.modules.nixos."desktop.programs.networking"
    self.modules.nixos.boot-loader-limine
    self.modules.nixos."hardware.hid-apple"
    self.modules.nixos."profiles.performance.zram"
    self.modules.nixos."profiles.compat"

    self.modules.nixos."services.dns.mosdns"
    self.modules.nixos."services.avahi"
    self.modules.nixos."services.console"
    self.modules.nixos."services.brightness"
    self.modules.nixos."services.uptermd"
    self.modules.nixos."services.proxy"
    self.modules.nixos."programs.evolution"
    self.modules.nixos."services.ollama"

    self.modules.nixos."services.databases"

    self.modules.nixos."services.virtualisation.podman"
    self.modules.nixos."services.virtualisation.qemu"
  ];

  networking.hostName = hostName;
  nixpkgs.hostPlatform = system;

  profiles.hardware.kvm = {
    enable = true;
    cpuVendor = "amd";
    ignoreMsrs = true;
  };
}
