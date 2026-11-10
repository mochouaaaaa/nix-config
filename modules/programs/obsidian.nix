{
  flake.modules.homeManager."desktop.programs" = { pkgs, ... }: {
    programs.obsidian = {
      enable = true;
      package = pkgs.obsidian;
      defaultSettings = {
        themes = [ "Catppuccin" ];
      };
    };
  };

  flake.modules.darwin.programs = {
    homebrew.casks = [ "obsidian" ];
  };
}
