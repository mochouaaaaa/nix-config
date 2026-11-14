{ self, ... }:
{
  # Reusable headless-friendly command-line environment. Git remains part of
  # this role; system-wide Home Manager defaults are selected by host instead.
  flake.modules.homeManager.cli = {
    imports = [
      self.modules.homeManager.programs
      self.modules.homeManager."cli.git"
    ];
  };
}
