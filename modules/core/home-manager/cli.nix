{ self, ... }:
{
  # Shared command-line environment, including the terminal editor, Git,
  # and directory-scoped environment management.
  flake.aspects."cli"."homeManager" = {
    imports = [
      self.modules.homeManager.programs
      self.modules.homeManager."cli.neovim"
      self.modules.homeManager."cli.direnv"
    ];
  };
}
