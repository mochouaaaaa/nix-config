_: {
  flake.aspects = { aspects, ... }: {
    cli = {
      includes = [
        aspects.cli._.git
        aspects.cli._.shells.zsh
        aspects.cli._.terminals.tmux
        aspects.cli._.system.ssh
        aspects.editors._.neovim
        aspects.cli._.direnv
      ];

      # Keep the aggregate available as a Home Manager module.
      homeManager = _: { };
    };
  };
}
