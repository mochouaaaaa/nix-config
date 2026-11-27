{
  flake.aspects = { aspects, ... }: {
    "programs.lazygit".homeManager = {
      programs.lazygit = {
        enable = true;
        shellWrapperName = "lazygit";
      };
    };

    "programs".includes = [
      aspects."programs.lazygit"
    ];
  };
}
