{
  flake.aspects = { aspects, ... }: {
    "programs.vscode".includes = [
      aspects.editors._.vscode
    ];
  };
}
