{
  pkgs,
  ...
}:
{
  boot = {

    initrd = {
      kernelModules = [ "amdgpu" ];
      systemd.emergencyAccess = true;
    };

    # kernelPackages = pkgs.linuxPackages_latest;
    kernelPackages = pkgs.linuxPackages_zen;

    kernelModules = [
      "vfio-pci"
      "ext4"
    ];
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
      limine = {
        extraEntries = ''
          /Windows
            protocol: efi
            path: uuid(d3e7ba79-ce08-4f78-bf4f-8c28d41ee039):/EFI/Microsoft/Boot/bootmgfw.efi
        '';
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
  };

  services.xserver = {
    videoDrivers = [ "amdgpu" ];
  };

  hardware = {
    amdgpu = {
      opencl.enable = true;
      initrd.enable = true;
      overdrive.enable = true;
    };
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    clinfo
    pkgsRocm.blender
  ];

  systemd.tmpfiles.rules = [
    "L+ /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

}
