{ ... }:
{
  # Platform-neutral workstation role. Platform-specific integration remains
  # in homeManager.linux and homeManager.darwin.
  flake.aspects = { aspects, ... }: {
    workstation = {
      includes = [
        aspects.cli
        aspects."development.languages"
        aspects."programs.vscode"
        aspects."programs.kitty"
        aspects."desktop.programs.database"
      ];

      # Keep the aggregate available as a Home Manager module.
      homeManager = { ... }: { };
    };
  };
}
