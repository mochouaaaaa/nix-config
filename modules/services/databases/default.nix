{
  flake.aspects = { aspects, ... }: {
    services.databases = {
      includes = [
        aspects.services._.mysql
        aspects.services._.postgresql
        aspects.services._.redis
      ];

      nixos = { ... }: { };
    };
  };
}
