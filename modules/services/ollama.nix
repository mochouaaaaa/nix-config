{
  # Ollama is an optional host service, not part of every desktop environment.
  flake.modules.homeManager."services.ollama" = { pkgs, ... }: {
    services.ollama = {
      enable = true;
      package = pkgs.ollama-rocm;
      acceleration = "rocm";
      environmentVariables = {
        HSA_OVERRIDE_GFX_VERSION = "10.3.0";
      };
    };
  };

  flake.modules.nixos."services.ollama" =
    {
      self,
      lib,
      config,
      username,
      ...
    }:
    {
      home-manager.users.${username}.imports = [
        self.modules.homeManager."services.ollama"
      ];

      profiles.preservation.users.${username}.directories =
        lib.optionals config.home-manager.users.${username}.services.ollama.enable
          [
            ".ollama"
          ];
    };

  flake.modules.homeManager.darwin = { lib, ... }: {
    services.ollama.enable = lib.mkForce false;
  };
}
