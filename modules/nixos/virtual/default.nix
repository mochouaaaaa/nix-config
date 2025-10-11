{
  lib,
  config,
  ...
}:
let
  cfg = config.modules'.virtual;
  importModules = [
    (lib.mkIf cfg.docker.enable ./docker.nix)
    (lib.mkIf cfg.qemu.enable ./qemu.nix)
    (lib.mkIf cfg.virtualbox.enable ./virtualbox.nix)
    (lib.mkIf cfg.vmware.enable ./vmware.nix)
  ];

  hasModules = lib.lists.length importModules > 0;
in
{
  options.modules'.virtual = {
    virtualbox.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable VirtualBox support.";
      default = false;
    };
    vmware.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable VMware support.";
      default = false;
    };
    qemu.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable QEMU support.";
      default = false;
    };
    docker.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable Docker support.";
      default = false;
    };
  };

  imports = lib.importModule' ./.;

  config = lib.mkIf hasModules {
    # For Intel:
    /*
      options kvm_intel nested=1
      options kvm_intel emulate_invalid_guest_state=0
      options kvm ignore_msrs=1
    */
    boot.kernelModules = lib.mkAfter [ "vfio-pci" ];
    services.spice-vdagentd.enable = true;
  };
}
