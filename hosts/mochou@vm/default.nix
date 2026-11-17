{
  inputs,
  username,
  hostName,
  system,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
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

  # SSH is enabled by the shared services.base module. Keep root access
  # key-only; the core users module mirrors the user's authorized keys to root.
  services.openssh.settings.PermitRootLogin = "prohibit-password";

  users.users.${username}.extraGroups = [
    "networkmanager"
    "wheel"
  ];

}
