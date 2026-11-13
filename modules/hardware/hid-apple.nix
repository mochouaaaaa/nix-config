{
  # Optional Apple keyboard and Magic Mouse kernel drivers.
  # Import explicitly on hosts that use this hardware.
  flake.modules.nixos."hardware.hid-apple" = {
    boot.kernelModules = [
      "hid_apple"
      "hid_magicmouse"
    ];
  };
}
