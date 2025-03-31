{
  lib,
  config,
  ...
}: let
  cfg = config.modules.virtual;
  importModules =
    []
    ++ lib.optionals (cfg.docker.enable) [./docker.nix]
    ++ lib.optionals (cfg.qemu.enable) [./qemu.nix]
    ++ lib.optionals (cfg.virtualbox.enable) [./virtualbox.nix]
    ++ lib.optionals (cfg.vmware.enable) [./vmware.nix];

  hasModules = lib.lists.length importModules > 0;
in {
  options.modules.virtual = {
    virtualbox.enable = lib.mkEnableOption "VirtualBox";
    vmware.enable = lib.mkEnableOption "VMware";
    qemu.enable = lib.mkEnableOption "QEMU";
    docker.enable = lib.mkEnableOption "Docker";
  };

  config = lib.mkIf hasModules {
    # For Intel:
    /*
    options kvm_intel nested=1
    options kvm_intel emulate_invalid_guest_state=0
    options kvm ignore_msrs=1
    */
    boot.kernelModules = ["vfio-pci"];
    services.spice-vdagentd.enable = true;
  };
}
