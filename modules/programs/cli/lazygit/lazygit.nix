{

  flake.modules.homeManager."programs.lazygit" = {
    programs.lazygit = {
      enable = true;
      shellWrapperName = "lazygit";
    };
  };

  flake.modules.homeManager.programs = { self, ... }: {

    imports = [ self.modules.homeManager."programs.lazygit" ];

  };
}
