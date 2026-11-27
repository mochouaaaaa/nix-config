{
  # Optional Apple keyboard and Magic Mouse kernel drivers.
  # Import explicitly on hosts that use this hardware.
  flake.aspects."hardware.hid-apple"."nixos" = {
    boot.kernelModules = [
      "hid_apple"
      "hid_magicmouse"
    ];
  };
}
