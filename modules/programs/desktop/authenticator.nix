{
  flake.modules.homeManager."desktop.programs.security" = { pkgs, ... }: {
    home.packages = [
      pkgs.ente-auth
      pkgs.authenticator
    ];
  };
}
