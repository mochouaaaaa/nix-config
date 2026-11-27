{
  flake.aspects = {
    cli.provides.lazygit.homeManager = {
      programs.lazygit = {
        enable = true;
        shellWrapperName = "lazygit";
      };
    };
  };
}
