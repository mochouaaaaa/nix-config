{ inputs, ... }:

let
  flakeAspectsLib = inputs.flake-aspects.lib inputs.nixpkgs.lib;
in
{
  flake.aspects = { aspects, ... }: {
    services.provides.ollama = {
      includes = [
        (flakeAspectsLib.forward {
          each = [ { userName = "mochou"; } ];
          fromClass = _: "homeManager";
          intoClass = _: "nixos";
          intoPath = user: [ "home-manager" "users" user.userName ];
          fromAspect = _: aspects.services._.ollama;
        })
      ];

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

      nixos = { ... }: { };
    };

    "preservation".nixos =
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
