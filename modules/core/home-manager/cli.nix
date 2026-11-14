{ self, ... }:
{
  # Reusable headless-friendly command-line environment. Git is a shared CLI
  # tool, while SSH client defaults are part of the common system baseline.
  flake.modules.homeManager.cli = {
    imports = [
      self.modules.homeManager.programs
      self.modules.homeManager."cli.git"
      self.modules.homeManager."system.ssh"
    ];
  };
}
