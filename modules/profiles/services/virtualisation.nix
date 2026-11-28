{
  flake.aspects = { aspects, ... }: {
    "services.virtualisation" = {
      includes = [
        aspects.services._.virtualisation.vm
        aspects.services._.virtualisation.podman
        aspects.services._.virtualisation.qemu
      ];

      nixos = _: { };
    };
  };
}
