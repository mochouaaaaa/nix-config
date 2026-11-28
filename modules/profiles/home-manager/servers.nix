{ ... }:
{
  # Headless/server role: shared CLI and administration tools without
  # graphical editors, terminal emulator, fonts, or desktop applications.
  flake.aspects = { aspects, ... }: {
    "servers" = {
      includes = [ aspects.cli ];
      homeManager = { ... }: { };
    };
  };
}
