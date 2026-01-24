{
  lib,
  config,
  ...
}:
{

  config = lib.mkIf (config.profiles.desktop.enable) {

    boot = {

      kernelModules = [
        "uhid" # 让用户态创建虚拟 HID 设备
        "hidp" # 蓝牙 HID 协议
        "hid_apple" # Apple 键盘/触控设备特殊功能支持
        "hid_magicmouse" # Magic Mouse 专属驱动
        "hid_multitouch" # 通用多点触控驱动
        "snd_aloop" # 声卡循环回路
      ];

      loader = {
        systemd-boot = {
          # we use Git for version control, so we don't need to keep too many generations.
          configurationLimit = lib.mkDefault 10;
          # pick the highest resolution for systemd-boot's console.
          consoleMode = lib.mkDefault "max";
        };

        timeout = lib.mkDefault 10; # wait for x seconds to select the boot entry
      };
    };

    # https://dev.leiyanhui.com/nixos/kvm-qemu/
    # <https://github.com/kholia/OSX-KVM>
    # Required by AMD boxes for OSX-KVM
    boot.extraModprobeConfig = ''
      options kvm_amd nested=1
      options bt_coex_active=0 swcrypto=1 11n_disable=8
      options kvm ignore_msrs=1 report_ignored_msrs=0
    '';

  };
}
