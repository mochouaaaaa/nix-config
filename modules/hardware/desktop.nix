{
  flake.aspects = { aspects, ... }: {
    "hardware.desktop" = {
      includes = [
        aspects."hardware.audio"
        aspects."hardware.bluetooth"
      ];

      nixos.boot.kernelModules = [
        "hid_multitouch"
      ];
    };
  };
}
