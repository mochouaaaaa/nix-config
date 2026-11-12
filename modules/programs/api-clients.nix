{
  flake.modules.homeManager."programs.api-clients" = { pkgs, ... }: {

    home.packages = [
      pkgs.cartero
      pkgs.hoppscotch
    ];

  };
}
