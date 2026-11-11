{
  flake.modules.homeManager.services-ollama = {
    services.ollama = {
      enable = true;
    };
  };

  flake.modules.homeManager."desktop.common" = { pkgs, ... }: {
    services.ollama = {
      package = pkgs.ollama-rocm;
      acceleration = "rocm";
      environmentVariables = {
        HSA_OVERRIDE_GFX_VERSION = "10.3.0";
      };
    };
  };

  flake.modules.nixos."desktop.common" =
    {
      self,
      lib,
      config,

      username,
      ...
    }:
    {
      home-manager.users.${username}.imports = [
        self.modules.homeManager.services-ollama
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
