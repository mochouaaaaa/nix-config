{
  lib,
  config,
  ...
}:
{

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

  fileSystems."/home" = {
    options = [
      "subvol=home"
      "compress-force=zstd"
    ];
  };

  fileSystems."/persistent" = {
    neededForBoot = true;
    fsType = "btrfs";
    options = [
      "subvol=persistent"
      "compress-force=zstd"
    ];
  };

  fileSystems."/nix" = {
    options = [
      "subvol=nix"
      "noatime"
      "compress-force=zstd"
    ];
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
}
