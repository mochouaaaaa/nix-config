{
  flake.aspects = { aspects, ... }: {
    cli.provides.programs = {
      includes = [ aspects.programs ];
    };
  };
}
