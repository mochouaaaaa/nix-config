{ ... }:
{
  flake.aspects = { aspects, ... }: {
    cli.includes = [
      aspects.programs
      aspects."cli.neovim"
      aspects."cli.direnv"
    ];
  };
}
