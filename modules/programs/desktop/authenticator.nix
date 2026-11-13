{
  flake.modules.homeManager."desktop.programs" = { pkgs, ... }: {
    home.packages = [
      pkgs.ente-auth
      pkgs.authenticator
    ];
  };
}
