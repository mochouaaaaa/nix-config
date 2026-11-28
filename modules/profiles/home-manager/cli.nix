_: {
  flake.aspects = { aspects, ... }: {
    cli = {
      includes = [
        aspects.cli._.git
        aspects.cli._.shells.zsh
        aspects.cli._.terminals.tmux
        aspects.cli._.system.ssh
        aspects.cli._.direnv
        aspects.cli._.core
        aspects.cli._.bat
        aspects.cli._.btop
        aspects.cli._.eza
        aspects.cli._.fastfetch
        aspects.cli._.fd
        aspects.cli._.jq
        aspects.cli._.nh
        aspects.cli._.ripgrep
        aspects.cli._.television
        aspects.cli._.fzf
        aspects.cli._.lazydocker
        aspects.cli._.lazygit
        aspects.cli._.yazi
        aspects.cli._.zoxide
        aspects.editors._.neovim
      ];

      # Keep the aggregate available as a Home Manager module.
      homeManager = _: { };
    };
  };
}
