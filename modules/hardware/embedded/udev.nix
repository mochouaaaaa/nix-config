{
  # System-level device rules for embedded development hardware.
  flake.modules.nixos."hardware.embedded.udev" = { pkgs, ... }: {
    services.udev.packages = with pkgs; [
      platformio
      openocd
      openfpgaloader
    ];
  };
}
