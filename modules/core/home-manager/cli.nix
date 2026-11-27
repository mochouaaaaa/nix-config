{
  flake.aspects = { ... }: {
    cli.provides.programs = {
      includes = [ "programs" ];
    };
  };
}
