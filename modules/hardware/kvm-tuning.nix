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

      config = lib.mkIf cfg.enable {
        boot.extraModprobeConfig = lib.concatStringsSep "\n" (
          lib.optional (cfg.cpuVendor == "amd") "options kvm_amd nested=1"
          ++ lib.optional (cfg.cpuVendor == "intel") "options kvm_intel nested=1"
          ++ lib.optional cfg.ignoreMsrs "options kvm ignore_msrs=1 report_ignored_msrs=0"
        );
      };
    };

  # Extend the shared assertions aspect; it is imported by the core NixOS aspect.
  flake.aspects.assertions.nixos =
    { lib, options, ... }:
    {
      assertions = [
        {
          assertion = lib.hasAttrByPath [ "profiles" "hardware" "kvm" ] options;
          message = ''
            KVM configuration is enabled in the host, but the KVM module is not imported.

            Import self.modules.nixos.hardware-kvm in the host configuration.
          '';
        }
      ];
    };
}
