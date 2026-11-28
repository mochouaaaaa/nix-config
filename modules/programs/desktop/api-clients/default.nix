{
  flake.aspects = { aspects, ... }: {
    desktop-api-clients.includes = [
      aspects.desktop-programs._.api-clients
    ];

    desktop-programs.provides.api-clients.homeManager = { pkgs, lib, ... }: {
      home.packages = [
        pkgs.hoppscotch
      ]
      ++ lib.optional (!pkgs.stdenv.hostPlatform.isDarwin) pkgs.cartero;
    };
  };
}
