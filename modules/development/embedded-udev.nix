{
  flake.modules.nixos.development =
    {
      pkgs,
      ...
    }:
    {
      services.udev.packages = with pkgs; [
        platformio
        openocd
        openfpgaloader
      ];
    };
}
