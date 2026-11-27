{
  flake.aspects."desktop.programs.security"."homeManager" = { pkgs, ... }: {
    home.packages = [
      pkgs.ente-auth
      pkgs.authenticator
    ];
  };

  flake.aspects."preservation"."nixos" =
    {
      lib,
      pkgs,
      config,
      username,
      ...
    }:
    let
      homePackages = config.home-manager.users.${username}.home.packages or [ ];
    in
    {
      profiles.preservation.users.${username}.directories =
        lib.optionals (lib.elem pkgs.authenticator homePackages) [
          {
            directory = ".local/share/authenticator";
            mode = "0755";
          }
        ]
        ++ lib.optionals (lib.elem pkgs.ente-auth homePackages) [
          {
            directory = ".local/share/io.ente.auth";
            mode = "0755";
          }
        ];
    };
}
