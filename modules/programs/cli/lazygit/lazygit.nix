{

  flake.aspects."programs.lazygit"."homeManager" = {
    programs.lazygit = {
      enable = true;
      shellWrapperName = "lazygit";
    };
  };

  flake.aspects."programs"."homeManager" = { self, ... }: {

    imports = [ self.modules.homeManager."programs.lazygit" ];

  };
}
