{ self, ... }:
{
  flake.modules.homeManager."cli.neovim.plugins" = {
    imports = [
      self.modules.homeManager."cli.neovim.plugins.treesitter"
    ];
  };
}
