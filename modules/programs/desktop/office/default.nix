{
  flake.aspects = { aspects, ... }: {
    desktop-office.includes = [
      aspects.desktop-programs._.office._.wps
    ];
  };
}
