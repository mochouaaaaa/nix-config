{
  flake.aspects."desktop.programs".provides.utilities.homeManager = { pkgs, ... }: {
    home.packages = [
      pkgs.dconf-editor
    ];
  };
}
