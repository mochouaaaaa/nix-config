{ ... }:
{
  flake.aspects = { aspects, ... }: {
    "cli.neovim.lsp".includes = [
      aspects."cli.neovim.lsp.nixd"
    ];
  };
}
