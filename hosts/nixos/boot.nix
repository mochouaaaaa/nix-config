{
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
  boot.kernelModules = ["kvm-amd" "vfio-pci" "ext4"];
  boot.extraModprobeConfig = "options kvm_amd nested=1"; # for amd cpu
  boot.extraModulePackages = [];

  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
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
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };
}
