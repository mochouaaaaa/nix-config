{
  lib,
  config,
  ...
}:
let
  vmwareMode = lib.hasAttr "vmware" config;
in
{

  config = lib.mkIf (!vmwareMode) {
    boot.extraModprobeConfig = lib.mkForce "options kvm_amd nested=1"; # for amd cpu
    boot.extraModulePackages = [ ];

    fileSystems."/" = {
      device = lib.mkForce "tmpfs";
      fsType = lib.mkForce "tmpfs";
      options = [
        "relatime"
        "mode=755"
      ];
    };

    fileSystems."/nix" = {
      options = [
        "subvol=nix"
        "noatime"
        "compress-force=zstd"
      ];
      neededForBoot = true;
    };

    fileSystems."/nix/persistence" = {
      fsType = "btrfs";
      options = [ "subvol=@rootfs,compress-force=zstd,noatime" ];
      depends = [ "/nix" ];
      neededForBoot = true;
    };

    fileSystems."/nix/persistence/home" = {
      fsType = "btrfs";
      options = [ "subvol=@home,compress-force=zstd,noatime" ];
      depends = [ "/nix/persistence" ];
    };

    fileSystems."/nix/persistence/var" = {
      fsType = "btrfs";
      options = [ "subvol=@var,compress-force=zstd,noatime" ];
      depends = [ "/nix/persistence" ];
      neededForBoot = true;
    };

    fileSystems."/boot" = {
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };

    networking.useDHCP = lib.mkForce false;
    # networking.interfaces.enp6s0.useDHCP = lib.mkDefault true;
    networking.interfaces.wlp5s0.useDHCP = lib.mkForce true;

    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  };
}
