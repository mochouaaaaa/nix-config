{
  flake.aspects = { aspects, ... }: {
    desktop-media.includes = [
      aspects.desktop-programs._.media._.live
      aspects.desktop-programs._.media._.mpv
      aspects.desktop-programs._.media._.splayer
    ];
  };
}
