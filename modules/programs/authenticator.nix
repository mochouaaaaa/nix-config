{
  flake.modules.homeManager."desktop.common" = { pkgs, ... }: {
    home.packages = [
      pkgs.ente-auth
      pkgs.authenticator
    ];
  };
}
