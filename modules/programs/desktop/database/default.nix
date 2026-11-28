{
  flake.aspects = { aspects, ... }: {
    desktop-database = { databases }: {
      includes = [
        aspects.desktop-programs._.database._.clients
      ]
      ++ map (database: aspects.desktop-programs._.database._.${database}) databases;
      nixos = _: { };
      darwin = _: { };
      homeManager = _: { };
    };
  };
}
