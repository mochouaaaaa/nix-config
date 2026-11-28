{
  flake.aspects = { aspects, ... }: {
    desktop-browsers = { browsers }: {
      includes = map (browser: aspects.desktop-programs._.browsers._.${browser}) browsers;
      homeManager = _: { };
    };
  };
}
