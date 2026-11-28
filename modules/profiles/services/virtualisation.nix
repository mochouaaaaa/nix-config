{
  flake.aspects = { aspects, ... }: {
    services-virtualisation = {
      includes = [
        aspects.services._.virtualisation._.vm
        aspects.services._.virtualisation._.podman
        aspects.services._.virtualisation._.qemu
      ];

      nixos = _: { };
    };
  };
}
