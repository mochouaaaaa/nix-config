{
  flake.modules.homeManager."desktop.programs.api-clients" = { pkgs, lib, ... }: {
    home.packages = [
      pkgs.hoppscotch
    ] ++ lib.optional (!pkgs.stdenv.hostPlatform.isDarwin) pkgs.cartero;
  };
}
