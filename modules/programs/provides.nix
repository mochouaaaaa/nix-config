{
  flake.aspects = { aspects, ... }: {
    programs.includes = [
      aspects.programs._.git
      aspects.programs._.shells.zsh
      aspects.programs._.terminals.tmux
      aspects.programs._.system.ssh
    ];
  };
}
