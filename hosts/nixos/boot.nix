{
  pkgs,
  lib,
  config,
  ...
}:
let
  vmwareMode = lib.hasAttr "vmware" config;
in
{
  boot = {

    # tmp.cleanOnBoot = true;

    initrd = {
      systemd.emergencyAccess = true;
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
    };

    kernelPackages = pkgs.linuxPackages_latest;

    kernelModules = [
      "kvm-amd"
      "vfio-pci"
      "ext4"
    ];
    extraModprobeConfig = "options kvm_amd nested=1"; # for amd cpu
    extraModulePackages = [ ];
    supportedFilesystems = [
      "ext4"
      "btrfs"
      "xfs"
      "ntfs"
      "fat"
      "vfat"
      "exfat"
    ];

    loader = {
      systemd-boot.enable = false;
      grub = {
        enable = lib.mkDefault true;
        device = lib.mkDefault "nodev";
        efiSupport = lib.mkDefault true;
        extraEntries = ''
          menuentry "Windows" {
                      search --file --no-floppy --set=root /EFI/Microsoft/Boot/bootmgfw.efi
                      chainloader (''${root})/EFI/Microsoft/Boot/bootmgfw.efi
                  }
          menuentry "Ubuntu24.10" {
                      insmod part_gpt
                      insmod fat
                      search --no-floppy --fs-uuid --set=root C14D-581B
                      chainloader /EFI/ubuntu/shimx64.efi
                  }
        '';
      };
      limine = {
        extraEntries = ''
          /Windows
            protocol: efi
            path: uuid(d3e7ba79-ce08-4f78-bf4f-8c28d41ee039):/EFI/Microsoft/Boot/bootmgfw.efi
        '';
      };
      efi = {
        canTouchEfiVariables = if vmwareMode then false else true;
        efiSysMountPoint = "/boot";
      };
    };
  };
}
