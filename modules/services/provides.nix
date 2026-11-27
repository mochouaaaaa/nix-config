{
  flake.aspects = { aspects, ... }: {
    services.base.includes = [
      aspects.services._.openssh
    ];
  };
}
