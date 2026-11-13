{ self, ... }:
{
  # Reusable headless-friendly command-line environment. The legacy
  # programs module currently collects CLI, shell, SSH/Git and tmux settings;
  # desktop applications are kept in desktop.programs.* aggregates.
  flake.modules.homeManager.cli = {
    imports = [ self.modules.homeManager.programs ];
  };
}
