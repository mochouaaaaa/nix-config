{
  flake.aspects."desktop.programs".provides.api-clients.homeManager = { pkgs, lib, ... }: {
    home.packages = [
      pkgs.hoppscotch
    ]
    ++ lib.optional (!pkgs.stdenv.hostPlatform.isDarwin) pkgs.cartero;
  };
}
