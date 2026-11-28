{
  flake.aspects = { aspects, ... }: {
    "hardware.hid-apple" = {
      includes = [ aspects.hardware._.hid-apple ];
      nixos = _: { };
    };

    "hardware.kvm" = {
      includes = [ aspects.hardware._.kvm ];
      nixos = _: { };
    };
  };
}
