{
  flake.aspects = { aspects, ... }: {
    "desktop.programs" = {
      includes = [
        aspects."desktop.programs.api-clients"
        aspects."desktop.programs.browsers"
        aspects."desktop.programs.audio"
        aspects."desktop.programs.security"
        aspects."desktop.programs.communication"
        aspects."desktop.programs.email"
        aspects."desktop.programs.media"
        aspects."desktop.programs.notes"
        aspects."desktop.programs.remote"
        aspects."desktop.programs.office"
        aspects."desktop.programs.database"
        aspects."desktop.programs.utilities"
      ];

      # Keep the aggregate available as a Home Manager module.
      homeManager = _: { };
    };
  };
}
