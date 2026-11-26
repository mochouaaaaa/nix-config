{ self, ... }:
{
  flake.modules.nixos."hardware.desktop" = {
    imports = [
      self.modules.nixos."hardware.audio"
      self.modules.nixos."hardware.bluetooth"
    ];
    boot.kernelModules = [
      "uhid"
      "hidp"
      "hid_multitouch"
      "snd_aloop"
    ];
  };
}
