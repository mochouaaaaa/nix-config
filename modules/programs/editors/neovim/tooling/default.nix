_: {
  flake.aspects = { aspects, ... }: {
    editors.provides.neovim.tooling.includes = [
      aspects.editors._.neovim.tooling.languages
      aspects.editors._.neovim.tooling.rules.rustfmt
    ];
  };
}
