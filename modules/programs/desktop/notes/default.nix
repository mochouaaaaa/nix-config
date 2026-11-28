{
  flake.aspects = { aspects, ... }: {
    desktop-notes.includes = [
      aspects.desktop-programs._.notes._.joplin
      aspects.desktop-programs._.notes._.obsidian
    ];
  };
}
