{ inputs, self, ... }:
{
  flake.aspects = { aspects, ... }: {
    "desktop.common" = {
      includes = [
        aspects."desktop.base"
        aspects."desktop.hardware"

        # Forward this Aspect's Home Manager class into the NixOS user module.
        (inputs.flake-aspects.lib.forward {
          each = [
            { userName = "mochou"; }
          ];

          fromClass = _: "homeManager";
          intoClass = _: "nixos";
          intoPath = user: [
            "home-manager"
            "users"
            user.userName
          ];
          fromAspect = _: aspects."desktop.common";
        })
      ];

      nixos = { };

      homeManager = {
        imports = [
          self.modules.homeManager."desktop.user"
        ];
      };
    };
  };
}
