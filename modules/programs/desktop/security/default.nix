{
  flake.aspects = { aspects, ... }: {
    desktop-security = { security }: {
      includes = map (program: aspects.desktop-programs._.security._.${program}) security;
      homeManager = _: { };
    };
  };
}
