{ ... }:
{
  flake.aspects = { aspects, ... }: {
    editors.provides.neovim.lsp.includes = [
      aspects.editors._.neovim.lsp.nixd
    ];
  };
}
