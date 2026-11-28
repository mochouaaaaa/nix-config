{
  flake.aspects.hardware.provides.kvm.nixos =
    { lib, config, ... }:
    let
      cfg = config.profiles.hardware.kvm;
    in
    {
      options.profiles.hardware.kvm = {
        enable = lib.mkEnableOption "KVM tuning (nested virtualization and optional MSR handling)";

        cpuVendor = lib.mkOption {
          type = lib.types.enum [
            "amd"
            "intel"
          ];
          default = "amd";
          description = "CPU vendor used to select the KVM kernel module.";
        };

        ignoreMsrs = lib.mkEnableOption "Ignore unhandled MSR accesses (needed by some macOS guests).";
      };

      config = {
        # This marker is checked by the independently imported assertion aspect.
        hardware.kvm.moduleImported = true;

        config = lib.mkIf cfg.enable {
          boot.extraModprobeConfig = lib.concatStringsSep "\n" (
            lib.optional (cfg.cpuVendor == "amd") "options kvm_amd nested=1"
            ++ lib.optional (cfg.cpuVendor == "intel") "options kvm_intel nested=1"
            ++ lib.optional cfg.ignoreMsrs "options kvm ignore_msrs=1 report_ignored_msrs=0"
          );
        };
      };
    };

  flake.aspects."hardware.kvm.assertions".nixos =
    { lib, config, ... }:
    {
      options.hardware.kvm.moduleImported = lib.mkOption {
        type = lib.types.bool;
        default = false;
        internal = true;
        description = "Whether the hardware.kvm aspect has been imported.";
      };

      config.assertions = [
        {
          assertion = config.hardware.kvm.moduleImported;
          message = "The hardware.kvm.assertions module is imported, but hardware.kvm is missing. Import self.modules.nixos.\"hardware.kvm\" in the host configuration.";
        }
      ];
    };
}
