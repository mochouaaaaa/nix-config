_: {
  flake.aspects = { aspects, ... }: {
    editors.provides.neovim.provides.lsp.includes = [
      aspects.editors._.neovim._.lsp._.nixd
    ];
  };
}
