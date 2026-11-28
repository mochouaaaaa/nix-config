{ inputs, ... }:
{
  flake.aspects = { aspects, ... }: {
    "desktop.umbriel" = {
      includes = [
        aspects."desktop.common"
        (inputs.flake-aspects.lib.forward {
          each = [ { userName = "mochou"; } ];
          fromClass = _: "homeManager";
          intoClass = _: "nixos";
          intoPath = user: [ "home-manager" "users" user.userName ];
          fromAspect = _: aspects."desktop.umbriel";
        })
      ];

      nixos = {
        programs.umbriel = {
          enable = true;
        };

        services.gvfs.enable = true;
      };
    };
  };
}
