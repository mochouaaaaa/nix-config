{ ... }:
{
  flake.aspects = { aspects, ... }: {
    cli = {
      includes = [
        aspects.programs
        aspects."cli.neovim"
        aspects."cli.direnv"
      ];

      # Keep the aggregate available as a Home Manager module.
      homeManager = { ... }: { };
    };
  };
}
