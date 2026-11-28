{
  flake.aspects.desktop-programs.provides.notes.provides.obsidian.homeManager = { pkgs, ... }: {
    programs.obsidian = {
      enable = true;
      cli.enable = true;
      package = pkgs.obsidian;
      defaultSettings = {
        themes = [ "Catppuccin" ];
      };
    };
  };

  flake.aspects."programs".darwin = {
    homebrew.casks = [ "obsidian" ];
  };
}
