{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
  boot.extraModprobeConfig = "options kvm_amd nested=1"; # for amd cpu
  boot.extraModulePackages = [];

  boot.supportedFilesystems =
    lib.mkForce ["ext4" "btrfs" "xfs" "ntfs" "fat" "vfat" "exfat"];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/0d8a4280-7271-4c8e-a9f2-e6abb3d332fd";
    fsType = "btrfs";
    options = ["subvol=root" "compress=zstd"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/0d8a4280-7271-4c8e-a9f2-e6abb3d332fd";
    fsType = "btrfs";
    options = ["subvol=home" "compress=zstd"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/0d8a4280-7271-4c8e-a9f2-e6abb3d332fd";
    fsType = "btrfs";
    options = ["subvol=nix" "noatime" "compress=zstd"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C14D-581B";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  # fileSystems."/mnt/external" = {
  #   device = "/dev/disk/by-uuid/C02459D22459CBD2";
  #   fsType = "ntfs-3g";
  #   options = [ "locale=zh_CN.UTF-8" ];
  # };

  swapDevices = [{device = "/dev/disk/by-uuid/32beffe1-99b8-4f18-8d6b-b241b572fcd8";}];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  # networking.useDHCP = lib.mkDefault true;
  # networking.wireless = {
  #   enable = true;
  #   networks = { TP-LINK-TEST = { psk = "P@ssw0rd"; }; };
  #
  # };
  # networking.interfaces.enp6s0.useDHCP = lib.mkDefault true;
  networking.interfaces.wlp5s0.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
