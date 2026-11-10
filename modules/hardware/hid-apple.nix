{
  flake.modules.nixos.hardware = {
    boot.kernelModules = [
      "hid_apple"
      "hid_magicmouse"
    ];
  };
}
