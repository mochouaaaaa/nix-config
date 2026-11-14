{ self, ... }:
{
  # Shared command-line environment, including the terminal editor, Git,
  # and directory-scoped environment management.
  flake.modules.homeManager.cli = {
    imports = [
      self.modules.homeManager.programs
      self.modules.homeManager."programs.git"
      self.modules.homeManager."cli.neovim"
      self.modules.homeManager."cli.direnv"
    ];
  };
}
