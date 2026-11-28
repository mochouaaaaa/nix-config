_: {
  flake.aspects = { aspects, ... }: {
    cli = {
      includes = [
        aspects.cli._.git
        aspects.cli._.shells.zsh
        aspects.cli._.terminals.tmux
        aspects.cli._.system.ssh
        aspects.cli._.direnv
        aspects.cli._.fzf
        aspects.cli._.yazi
        aspects.cli._.zoxide
        aspects.editors._.neovim
      ];

      # Keep the aggregate available as a Home Manager module.
      homeManager = _: { };
    };
  };
}
