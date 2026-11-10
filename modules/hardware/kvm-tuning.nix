{
  flake.modules.nixos.hardware =
    { lib, config, ... }:
    let
      cfg = config.profiles.hardware.kvm;
    in
    {
      options.profiles.hardware.kvm = {
        enable = lib.mkEnableOption "KVM tuning (nested virtualization and optional MSR handling)";

        cpuVendor = lib.mkOption {
          type = lib.types.enum [ "amd" "intel" ];
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
}
