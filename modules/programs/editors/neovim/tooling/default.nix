{ self, ... }:
{
  flake.modules.homeManager."cli.neovim.tooling" = {
    imports = [
      self.modules.homeManager."cli.neovim.tooling.languages"
      self.modules.homeManager."cli.neovim.tooling.rules.rustfmt"
    ];
  };
}
