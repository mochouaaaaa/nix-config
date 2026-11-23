{
  flake.modules.homeManager.programs = {
    programs.lazygit = {
      enable = true;
      shellWrapperName = "lazygit";
      settings = { };
    };
  };
}
