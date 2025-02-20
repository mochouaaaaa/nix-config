{lib, ...}: {
  boot.loader = {
    systemd-boot = {
      # we use Git for version control, so we don't need to keep too many generations.
      configurationLimit = lib.mkDefault 10;
      # pick the highest resolution for systemd-boot's console.
      consoleMode = lib.mkDefault "max";
    };

    timeout = lib.mkDefault 10; # wait for x seconds to select the boot entry
  };

  # for power management
  services = {
    power-profiles-daemon = {enable = true;};
    upower.enable = true;
  };

  # https://dev.leiyanhui.com/nixos/kvm-qemu/
  # <https://github.com/kholia/OSX-KVM>
  # Required by AMD boxes for OSX-KVM
  boot.extraModprobeConfig = ''
    options kvm_amd nested=1
    options bt_coex_active=0 swcrypto=1 11n_disable=8
    options kvm ignore_msrs=1 report_ignored_msrs=0
  '';
}
