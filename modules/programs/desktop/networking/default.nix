{
  flake.aspects = { aspects, ... }: {
    desktop-networking = { networking }: {
      includes = map (program: aspects.desktop-programs._.networking._.${program}) networking;
      nixos = _: { };
      darwin = _: { };
    };
  };
}
