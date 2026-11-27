_: {
  # Atomic language modules remain independently importable.
  flake.aspects = { aspects, ... }: {
    "development.languages".includes = [
      aspects."development.go"
      aspects."development.node"
      aspects."development.python"
      aspects."development.rust"
    ];
  };
}
