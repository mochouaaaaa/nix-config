{
  flake.aspects = { aspects, ... }: {
    desktop-remote.includes = [
      aspects.desktop-programs._.remote._.remmina
      aspects.desktop-programs._.remote._.rustdesk
    ];
  };
}
