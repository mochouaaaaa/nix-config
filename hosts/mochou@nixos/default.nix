{
  self,
  username,
  hostName,
  system,
  ...
}:

{
  imports = [
    self.modules.nixos."host.${username}.${hostName}"
    self.modules.nixos.agenix
    self.modules.nixos.preservation

    self.modules.nixos.services-virtualisation
    self.modules.nixos."host.${username}.${hostName}.desktop-niri"
    self.modules.nixos."host.${username}.${hostName}.desktop-flatpak"
    self.modules.nixos.boot-loader-limine
    self.modules.nixos.hardware-hid-apple
    self.modules.nixos.hardware-kvm
    self.modules.nixos."profiles.performance.zram"
    self.modules.nixos.profiles-compat

    self.modules.nixos.services-dns-mosdns
    self.modules.nixos.services-avahi
    self.modules.nixos.services-console
    self.modules.nixos.services-brightness
    self.modules.nixos.services-uptermd
    self.modules.nixos.services-proxy
    self.modules.nixos."host.${username}.${hostName}.services-ollama"

  ];

  networking.hostName = hostName;
  nixpkgs.hostPlatform = system;

  profiles.hardware.kvm = {
    enable = true;
    cpuVendor = "amd";
    ignoreMsrs = true;
  };
}
