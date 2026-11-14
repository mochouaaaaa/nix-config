{
  flake.modules.homeManager."desktop.programs.api-clients" = { pkgs, ... }: {
    home.packages = [
      pkgs.cartero
      pkgs.hoppscotch
    ];
  };
}
