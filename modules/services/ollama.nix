{
  flake.aspects = {
    services.provides.ollama = {
      homeManager = { pkgs, ... }: {
        services.ollama = {
          enable = true;
          package = pkgs.ollama-rocm;
          acceleration = "rocm";
          environmentVariables = {
            HSA_OVERRIDE_GFX_VERSION = "10.3.0";
          };
        };
      };

      nixos = _: { };
    };

    preservation.nixos =
      {
        lib,
        config,
        username,
        ...
      }:
      {
        profiles.preservation.users.${username}.directories =
          lib.optionals config.home-manager.users.${username}.services.ollama.enable
            [
              ".ollama"
            ];
      };

    "darwin".homeManager = { lib, ... }: {
      services.ollama.enable = lib.mkForce false;
    };
  };
}
