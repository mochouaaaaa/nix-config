{
  lib,
  ...
}:
{

  boot.extraModprobeConfig = lib.mkForce "options kvm_amd nested=1"; # for amd cpu
  boot.extraModulePackages = [ ];

  fileSystems = {
    "/" = {
      device = lib.mkForce "tmpfs";
      fsType = lib.mkForce "tmpfs";
      options = [
        "relatime"
        "mode=755"
      ];
    };

    "/nix" = {
      options = [
        "subvol=nix"
        "noatime"
        "compress-force=zstd"
      ];
      neededForBoot = true;
    };

    "/nix/persistence" = {
      fsType = "btrfs";
      options = [ "subvol=@rootfs,compress-force=zstd,noatime" ];
      depends = [ "/nix" ];
      neededForBoot = true;
    };

    "/nix/persistence/home" = {
      fsType = "btrfs";
      options = [ "subvol=@home,compress-force=zstd,noatime" ];
      depends = [ "/nix/persistence" ];
    };

    "/nix/persistence/var" = {
      fsType = "btrfs";
      options = [ "subvol=@var,compress-force=zstd,noatime" ];
      depends = [ "/nix/persistence" ];
    };

    "/boot" = {
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
