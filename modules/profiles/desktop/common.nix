{ ... }:
{
  flake.aspects = { aspects, ... }: {
    "desktop.common" = {
      includes = [
        aspects."desktop.base"
        aspects."desktop.hardware"
        aspects."desktop.user"
      ];

      nixos = { ... }: { };
      homeManager = { ... }: { };
    };
  };
}
