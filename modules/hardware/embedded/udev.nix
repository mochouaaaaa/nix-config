{
  # System-level device rules for embedded development hardware.
  flake.aspects."hardware.embedded.udev"."nixos" = { pkgs, ... }: {
    services.udev.packages = with pkgs; [
      platformio
      openocd
      openfpgaloader
    ];
  };
}
