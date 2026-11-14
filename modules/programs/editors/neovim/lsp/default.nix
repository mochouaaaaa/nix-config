{ self, ... }:
{
  flake.modules.homeManager."cli.neovim.lsp" = {
    imports = [
      self.modules.homeManager."cli.neovim.lsp.nixd"
    ];
  };
}
