{
  # Ollama is an optional host service, not part of every desktop environment.
  flake.aspects.services.provides.ollama."homeManager" = { pkgs, ... }: {
    services.ollama = {
      enable = true;
      package = pkgs.ollama-rocm;
      acceleration = "rocm";
      environmentVariables = {
        HSA_OVERRIDE_GFX_VERSION = "10.3.0";
      };
    };
  };

  flake.aspects.services.provides.ollama."nixos" =
    { pkgs, username, ... }:
    {
      home-manager.users.${username}.services.ollama = {
        enable = true;
        package = pkgs.ollama-rocm;
        acceleration = "rocm";
        environmentVariables = {
          HSA_OVERRIDE_GFX_VERSION = "10.3.0";
        };
      };
    };

  flake.aspects."preservation"."nixos" =
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

  flake.aspects."darwin"."homeManager" = { lib, ... }: {
    services.ollama.enable = lib.mkForce false;
  };
}
