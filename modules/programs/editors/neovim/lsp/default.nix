{ self, ... }:
{
  flake.aspects."cli.neovim.lsp"."homeManager" = {
    imports = [
      self.modules.homeManager."cli.neovim.lsp.nixd"
    ];
  };
}
