{
  lib,
  myvars,
  ...
}: let
  importModules =
    []
    ++ lib.optionals (myvars.virtual.docker) [./docker.nix]
    ++ lib.optionals (myvars.virtual.qemu) [./qemu.nix]
    ++ lib.optionals (myvars.virtual.virtualbox) [./virtualbox.nix]
    ++ lib.optionals (myvars.virtual.vmware) [./vmware.nix];

  hasModules = lib.lists.length importModules > 0;
in {
  imports = importModules;
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
