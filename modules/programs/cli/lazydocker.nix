{
  flake.aspects = {
    cli.provides.lazydocker.homeManager =
      {
        lib,
        pkgs,
        config,
        ...
      }:
      {

        programs.lazydocker = {
          enable = true;
          settings = { };
        };

        home.packages = lib.optionals config.programs.lazydocker.enable [
          # docker
          pkgs.dockerfile-language-server
          pkgs.docker-compose-language-service
        ];

      };
  };
}
