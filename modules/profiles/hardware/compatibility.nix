{
  flake.aspects = { aspects, ... }: {
    "hardware.hid-apple" = {
      includes = [ aspects.hardware._.hid-apple ];
      nixos = _: { };
    };
  };
}
