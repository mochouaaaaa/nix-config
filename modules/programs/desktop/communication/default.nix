{
  flake.aspects = { aspects, ... }: {
    desktop-communication = { communication }: {
      includes = map (program: aspects.desktop-programs._.communication._.${program}) communication;
      homeManager = _: { };
    };
  };
}
