{
  inputs,
  self,
  username,
  hostName,
  system,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    self.modules.nixos."host.mochou.remote"
    self.modules.nixos.preservation
  ];

  networking.hostName = hostName;
  networking.networkmanager.enable = true;
  nixpkgs.hostPlatform = system;

  # Generic QEMU/UTM guest hardware.
  boot.initrd.availableKernelModules = [
    "ahci"
    "virtio_pci"
    "virtio_blk"
    "virtio_scsi"
    "xhci_pci"
    "usbhid"
    "sd_mod"
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  services.qemuGuest.enable = true;

  users.users.${username}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIECNEOhSUgaHrFy8WYaHcFTTyeBDaS2bNXj/mE7RCkGo nn.mochou+github@gmail.com"
  ];
}
