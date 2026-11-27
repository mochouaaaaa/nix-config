{
  flake.aspects = { aspects, ... }: {
    "hardware.desktop" = {
      includes = [
        aspects.hardware._.audio
        aspects.hardware._.bluetooth
      ];

      nixos.boot.kernelModules = [
        "hid_multitouch"
      ];
    };
  };
}
