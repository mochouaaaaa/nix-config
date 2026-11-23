{
  flake.modules.homeManager.programs =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {

      programs.lazydocker = {
        settings = { };
      };

      home.packages = lib.optionals config.programs.lazydocker.enable [
        # docker
        pkgs.dockerfile-language-server
        pkgs.docker-compose-language-service
      ];

    };
}
