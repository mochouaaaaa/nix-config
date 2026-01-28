{ lib, ... }:
{
  # ==================build-vm========================
  virtualisation.vmVariant = {

    virtualisation = {
      memorySize = 12000;
      cores = 6;
      # qemu.options = [
      #   "-nographic"
      #   "-serial mon:stdio"
      #   "-netdev user,id=net0,hostfwd=tcp::2222-:22"
      #   "-device virtio-net-pci,netdev=net0"
      # ];
    };

    # networking.networkmanager.enable = lib.mkForce false;

    boot.loader.grub = {
      gfxmodeBios = lib.mkForce "1024x768";
    };

    boot.kernel.sysctl = {
      "vm.swappiness" = 180;
      "vm.vfs_cache_pressure" = 50;
    };

    boot.initrd.availableKernelModules = [
      "virtio_net"
      "virtio_pci"
    ];

  };

}
