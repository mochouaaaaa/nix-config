{
  flake.aspects."desktop.programs.api-clients".homeManager = { pkgs, lib, ... }: {
    home.packages = [
      pkgs.hoppscotch
    ]
    ++ lib.optional (!pkgs.stdenv.hostPlatform.isDarwin) pkgs.cartero;
  };
}
