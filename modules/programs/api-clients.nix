{
  flake.modules.homeManager.api-clients = { pkgs, ... }: {

    home.packages = [
      pkgs.cartero
      pkgs.hoppscotch
    ];

  };
}
