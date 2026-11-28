{
  flake.aspects = { aspects, ... }: {
    desktop-vscode.includes = [
      aspects.editors._.vscode
    ];
  };
}
