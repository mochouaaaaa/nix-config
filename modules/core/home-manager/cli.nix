{ self, ... }:
{
  # Shared command-line environment, including the terminal editor and Git.
  flake.modules.homeManager.cli = {
    imports = [
      self.modules.homeManager.programs
      self.modules.homeManager."programs.git"
      self.modules.homeManager."cli.neovim"
    ];
  };
}
