{ self, ... }:
{
  flake.aspects = { aspects, ... }: {
    "desktop.common" = {
      includes = [
        aspects."desktop.base"
        aspects."desktop.hardware"
      ];

      nixos = { };

      homeManager = {
        imports = [
          self.modules.homeManager."desktop.user"
        ];
      };
    };
  };

  # Keep the Home Manager compatibility entry separate from the NixOS aspect.
  flake.modules.homeManager."desktop.common" = {
    imports = [
      self.modules.homeManager."desktop.user"
    ];
  };
}
