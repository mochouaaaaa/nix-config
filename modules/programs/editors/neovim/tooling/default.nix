_: {
  flake.aspects = { aspects, ... }: {
    editors.provides.neovim.provides.tooling.includes = [
      aspects.editors._.neovim._.tooling._.languages
      aspects.editors._.neovim._.tooling._.rules._.rustfmt
    ];
  };
}
